class PlayerSerializer < ActiveModel::Serializer
  attributes :id, :email, :session_token
end
