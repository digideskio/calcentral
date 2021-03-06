describe CampusOracle::UserAttributes do

  context 'obtaining user attributes feed' do

    subject {CampusOracle::UserAttributes.new(user_id: uid).get_feed_internal}

    shared_examples_for 'a parser for roles' do |expected_roles|
      it 'only sets expected roles' do
        set_roles = subject[:roles].select {|key, val| val}.keys.sort
        expect(set_roles).to eq expected_roles.sort
      end
    end

    context 'working against test data', if: CampusOracle::Queries.test_data? do
      context 'student with blank REG_STATUS_CD' do
        let(:uid) {300847}
        shared_examples 'expected feed values' do
          it 'includes expected feed values' do
            expect(subject[:education_level]).to eq 'Masters'
            expect(subject[:reg_status][:code]).to eq ' '
            expect(subject[:reg_status][:summary]).to eq 'Not Registered'
            expect(subject[:reg_status][:explanation]).to eq 'In order to be officially registered, you must pay at least 20% of your registration fees, have no outstanding blocks, and be enrolled in at least one class.'
            expect(subject[:reg_status][:needsAction]).to eq true
          end
        end
        context 'normal term' do
          include_examples 'expected feed values'
          it 'does not report term transition' do
            expect(subject[:reg_status]).not_to include(:transitionTerm)
          end
          it 'suppresses residency status' do
            expect(subject[:california_residency]).to eq nil
          end
        end
        context 'term transition' do
          before { Settings.terms.stub(:fake_now).and_return(DateTime.parse('2013-07-10')) }
          include_examples 'expected feed values'
          it 'reports term transition' do
            expect(subject[:reg_status][:transitionTerm]).to eq true
          end
          it 'omits residency status' do
            expect(subject[:california_residency]).to eq nil
          end
        end
      end
      context 'student with Education Abroad REG_SPECIAL_PGM_CD' do
        let(:uid) {300853}
        it 'includes expected feed values' do
          expect(subject[:education_abroad]).to be_truthy
        end
      end
      describe 'roles' do
        context 'student' do
          let(:uid) {300846}
          it_behaves_like 'a parser for roles', [:student, :registered, :undergrad]
        end
        context 'staff member and ex-student' do
          let(:uid) {238382}
          it_behaves_like 'a parser for roles', [:exStudent, :staff]
        end
        context 'user without affiliations data' do
          let(:uid) {321765}
          it_behaves_like 'a parser for roles', []
        end
        context 'guest' do
          let(:uid) {19999969}
          it_behaves_like 'a parser for roles', [:guest]
        end
        context 'concurrent enrollment student' do
          let(:uid) {321703}
          it_behaves_like 'a parser for roles', [:concurrentEnrollmentStudent]
        end
        context 'user with expired CalNet account' do
          let(:uid) {6188989}
          it_behaves_like 'a parser for roles', [:student, :registered, :expiredAccount, :graduate]
        end
      end
    end

  end

end
