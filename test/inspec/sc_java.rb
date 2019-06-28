# test commands
describe command('/usr/bin/env java -version') do
  its('stderr') { should match '/*openjdk version "11/*' }
  its('exit_status') { should cmp 0 }
end
