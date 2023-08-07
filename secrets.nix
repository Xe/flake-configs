let
  xe = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPg9gYKVglnO2HQodSJt4z4mNrUSUiyJQ7b+J798bwD9 cadey@shachi"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM6NPbPIcCTzeEsjyx0goWyj6fr2qzcfKCCdOUqg0N/v cadey@kos-mos"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMOyr7PjUfbALe3+zgygnL0fQz4GhQ7qT9b0Lw+1Gzwk cadey@lufta"
  ];

  hosts = [
    # akko
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKTRkq4ZX6hckN+WlChBoQyoNfB3c+QTNO0HwGaMq/cc"

    # chrysalis
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGDA5iXvkKyvAiMEd/5IruwKwoymC8WxH4tLcLWOSYJ1"

    # firgu
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB8+mCR+MEsv0XYi7ohvdKLbDecBtb3uKGQOPfIhdj3C"

    # itsuki
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP0eD0K2FqhkkIsUrYfmHigwbaUgOSotdSsNlLMRJiqx"

    # kos-mos
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINT+TxO1wYtifFcd7b5+asgImZb5ReLV1dTj6C2qgKzK"

    # lufta
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMADhGV0hKt3ZY+uBjgOXX08txBS6MmHZcSL61KAd3df"

    # logos
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC/P13gDGzvfbCRwLD6hXnnH8VRYLOCiQ7kbIMTK9I2w"

    # ontos
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJ0MKlPgIfnS9T/sh57tz4pL5DND4RU7bXvhNCLo+8g"

    # pneuma
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFMYB+fI24NlIA+Zc7G/3whu8vK4+EdGKkygrE++zTXq"
  ];

  publicKeys = xe ++ hosts;
in {
  "hosts/chrysalis/secret/mara.age".publicKeys = publicKeys;
  "hosts/firgu/secret/cf.env.age".publicKeys = publicKeys;
  "hosts/firgu/secret/snoo2nebby.age".publicKeys = publicKeys;

  "secret/aws-within.website.age".publicKeys = publicKeys;
  "secret/robocadey.age".publicKeys = publicKeys;
  "secret/sanguisuga.ts.age".publicKeys = publicKeys;
  "secret/vest-pit-near.age".publicKeys = publicKeys;
  "secret/akko-keyid.age".publicKeys = publicKeys;
  "secret/akko-applicationkey.age".publicKeys = publicKeys;
}
