let
  xe = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPg9gYKVglnO2HQodSJt4z4mNrUSUiyJQ7b+J798bwD9 cadey@shachi"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPYr9hiLtDHgd6lZDgQMkJzvYeAXmePOrgFaWHAjJvNU cadey@kos-mos"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMOyr7PjUfbALe3+zgygnL0fQz4GhQ7qT9b0Lw+1Gzwk cadey@lufta"
  ];

  hosts = [
    # chrysalis
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGDA5iXvkKyvAiMEd/5IruwKwoymC8WxH4tLcLWOSYJ1"

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
  "hosts/firgu/secret/cf.env.age".publicKeys = publicKeys;
  "hosts/firgu/secret/snoo2nebby.age".publicKeys = publicKeys;
}
