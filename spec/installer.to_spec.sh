Describe "Root specfile"
  Describe "try"
    It "curl and get HTTP 200"
      When call curl -s -o /dev/null -w "%{http_code}" https://installer.to
      The output should eq "200"
    End
  End
End
