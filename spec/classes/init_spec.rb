require 'spec_helper'
describe 'sc_java' do

  context 'with defaults for all parameters' do
    it { should contain_class('sc_java') }
  end
end
