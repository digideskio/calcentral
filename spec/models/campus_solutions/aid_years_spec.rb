require 'spec_helper'

describe CampusSolutions::AidYears do
  #
  # context 'mock proxy' do
  #   let(:fake_proxy) { CampusSolutions::AidYears.new(fake: true) }
  #   let(:feed) { fake_proxy.get[:feed] }
  #   it_behaves_like 'a proxy that properly observes the finaid feature flag'
  #   it 'returns data with the expected structure' do
  #     expect(feed['finaidSummary']['finaidYears']).to be
  #   end
  #   it 'can be overridden to return errors' do
  #     fake_proxy.set_response(status: 506, body: '')
  #     response = fake_proxy.get
  #     expect(response[:errored]).to eq true
  #   end
  #
  # end


  shared_examples 'a proxy that gets data' do
    subject { proxy.get }
    it_should_behave_like 'a simple proxy that returns errors'
    it_behaves_like 'a proxy that properly observes the finaid feature flag'
    it 'returns data with the expected structure' do
      expect(subject[:feed]['finaidSummary']['finaidYears']).to be
    end
  end

  context 'mock proxy' do
    let(:proxy) { CampusSolutions::AidYears.new(fake: true) }
    it_should_behave_like 'a proxy that gets data'
  end

  context 'real proxy', testext: true do
    let(:proxy) { CampusSolutions::AidYears.new(fake: false) }
    it_should_behave_like 'a proxy that gets data'
  end

end
