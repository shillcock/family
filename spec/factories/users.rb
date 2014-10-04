# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    first_name "MyString"
    last_name "MyString"
    email "MyString"
    birthday "2014-10-03"
    avatar_url "MyString"
    provider "MyString"
    uid "MyString"
    oauth_token "MyString"
    oauth_expires_at "2014-10-03 23:50:11"
  end
end
