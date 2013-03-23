require 'spec_helper'

describe 'Creating a character' do
  include_context 'logged in'

  it 'succeeds with valid input' do
    xhr :post, '/characters', Fabricate.attributes_for(:character)
    expect(response).to be_jsend_success
    expect(response.jsend_data[:id]).to be
  end

  it 'fails with invalid input' do
    xhr :post, '/characters', {}
    expect(response).to be_jsend_failure
  end
end
