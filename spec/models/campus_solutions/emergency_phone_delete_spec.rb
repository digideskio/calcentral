describe CampusSolutions::EmergencyPhoneDelete do

  let(:user_id) { '12345' }

  context 'deleting an emergency phone' do
    let(:params) { {} }
    let(:proxy) { CampusSolutions::EmergencyPhoneDelete.new(fake: true, user_id: user_id, params: params) }

    context 'converting params to Campus Solutions field names' do
      let(:params) { {
        bogus: 'foo',
        contactName: 'Joe',
        phoneType: 'LOCL'
      } }
      subject {
        proxy.construct_cs_post(params)
      }
      it 'should convert the CalCentral params to Campus Solutions params without exploding on bogus fields' do
        expect(subject[:query].keys.length).to eq 3
        expect(subject[:query][:CONTACT_NAME]).to eq 'Joe'
        expect(subject[:query][:PHONE_TYPE]).to eq 'LOCL'
      end
    end

    context 'performing a delete' do
      let(:params) { {
        contactName: 'Joe',
        phoneType: 'LOCL'
      } }
      subject {
        proxy.get
      }
      it_should_behave_like 'a simple proxy that returns errors'
      it_behaves_like 'a proxy that properly observes the profile feature flag'
      it_behaves_like 'a proxy that got data successfully'
    end
  end

end
