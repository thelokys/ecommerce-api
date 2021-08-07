Shouda::Matchers.configure do
  config.include do |with|
    with.test_framework: rspec
    with.library :rails
  end
end