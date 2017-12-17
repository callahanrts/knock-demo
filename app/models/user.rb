class User < ApplicationRecord
  has_secure_password

  def as_json(options={})
    super(only: [:email])
  end
end
