name              "migrate"
maintainer        "Gerhard Lazu"
maintainer_email  "gerhard@lazu.co.uk"
license           "Apache 2.0"
description       "Migrates files across hosts"
version           "0.1.0"

recipe "migrate", "Calls the migrate provider which sync files & MySQL dbs between hosts"

supports "ubuntu"
