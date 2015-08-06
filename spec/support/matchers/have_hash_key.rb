RSpec::Matchers.define :have_hash_key do |expected|
  match do |actual|
    CoreExt::HashMethods.retrieve_value(actual, expected).present?
  end
end
