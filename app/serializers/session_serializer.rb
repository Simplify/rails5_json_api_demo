class SessionSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :token
end