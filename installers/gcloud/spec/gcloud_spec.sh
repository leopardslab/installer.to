Describe "Installer script for"
  setup() { ./test.sh; }
  Before 'setup'
  Describe "gcloud"
    It "should install with curl"
      When call bash -c "gcloud --version"
      The output should include "Google Cloud SDK"
    End
  End
End
