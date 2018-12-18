RSpec.describe "sessions", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:headers) { { HTTP_ACCEPT: 'application/json' } }

  describe 'POST /api/v1/auth/sign_in' do
    it 'valid credentials returns user' do
      post '/api/v1/auth/sign_in',
      params: { email: user.email, password: user.password },
      headers: headers

      expected_response = {
        'data' => {
          'id' => user.id, "allow_password_change"=>false, 'uid' => user.email, 'email' => user.email,
          'provider' => 'email', 'name' => nil, 'nickname' => nil, 'image' => nil
        }
      }

      expect(response_json). to eq expected_response
    end

    it 'invalid email return error message' do
      post '/api/v1/auth/sign_in', params: { email: 'email@dot.com', password: user.password }, headers: headers

      expect(response_json['errors']).to eq ['Invalid login credentials. Please try again.']
      expect(response.status).to eq 401
    end

    it 'invalid password returns error message' do
      post '/api/v1/auth/sign_in', params: { email: user.email, password: 'dudududud' }, headers: headers

      expect(response_json['errors']).to eq ['Invalid login credentials. Please try again.']
      expect(response.status).to eq 401
    end
  end
end
