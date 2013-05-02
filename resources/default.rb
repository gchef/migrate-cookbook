actions :files, :mysqldump
default_action :files

attribute :db_dump_remove,   :equal_to => [true, false],  :default => true
attribute :db_dump_path,     :default => "/var/tmp"
attribute :db_name
attribute :db_password
attribute :db_user
attribute :force,            :equal_to => [true, false],  :default => false
attribute :group
attribute :host,             :required => true
attribute :local_path,       :required => true
attribute :remote_path
attribute :owner,            :default => "root"
attribute :rsync_options,    :default => "--recursive --copy-links --verbose --progress --checksum --perms"
attribute :user,             :default => "root"

def _group
  group || owner
end
