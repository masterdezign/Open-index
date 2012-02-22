require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*/*_test.rb'] + FileList['test/handlers/*/*_test.rb']
end
