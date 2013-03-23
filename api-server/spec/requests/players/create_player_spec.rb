require 'spec_helper'

describe 'Creating a player' do
  it 'succeeds with valid input' do
    xhr :post, '/players', Fabricate.attributes_for(:player)
    expect(response).to be_jsend_success
    expect(response.jsend_data[:id]).to be
  end

  it 'fails with invalid input' do
    xhr :post, '/players', {}
    expect(response).to be_jsend_failure
  end
end
