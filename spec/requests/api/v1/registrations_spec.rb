RSpec.describe 'User Registration', type: :request do
  let(:headers) { { HTTP_ACCEPT: 'Application/json' } }

  context 'with valid credentials' do
    it 'returns a user and token' do
      post '/api/v1/auth',
      params: { email: 'achie@linda.com', password: 'dodododo', confirm_password: 'dodododo'},
      headers: headers

      expect(response_json['status']).to eq 'success'
      expect(response.status).to be 200
    end
  end

  context 'returns error message when user submits' do
    it 'non-matching password' do
      post '/api/v1/auth',
      params: { email: 'achie@linda.com', password: 'dededede', password_confirmation: 'dodododo' },
      headers: headers

      expect(response_json['errors']['password_confirmation']).to eq ["doesn't match Password"]
      expect(response.status).to be 422
    end

    it 'wrong email format' do
      post '/api/v1/auth',
      params: { email: 'achie.linda.com', password: 'dededede', password_confirmation: 'dodododo' },
      headers: headers


      expect(response_json['errors']['email']).to eq ['is not an email']
      expect(response.status).to be 422
    end

    it 'already submitted email' do
      FactoryBot.create(:user, email: 'achie@linda.com', password: 'wanwanwan', password_confirmation: 'wanwanwan')
      post '/api/v1/auth',
      params: { email: 'achie@linda.com', password: 'dededede', confirm_password: 'dodododo' },
      headers: headers

      expect(response_json['errors']['email']).to eq ["has already been taken"]
      expect(response.status).to eq 422
    end
  end
end
