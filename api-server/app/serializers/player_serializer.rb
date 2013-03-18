class PlayerSerializer < ActiveModel::Serializer
  attributes :id, :email, :sessionToken

  def sessionToken
    object.session_token
  end
end
