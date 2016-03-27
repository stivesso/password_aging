require 'spec_helper'
describe 'password_aging' do

  context 'with defaults for all parameters' do
    it { should contain_class('password_aging') }
  end
end
