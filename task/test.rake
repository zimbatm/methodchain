
desc "Runs the tests"
task :test do
  sh "bacon -Ilib --automatic --quiet"
end

desc "Runs the tests with ruby 1.9"
task :test19 do
  sh "ruby1.9 -S bacon -Ilib --automatic --quiet"
end
