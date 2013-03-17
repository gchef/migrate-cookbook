action :files do
  if migrate?
    execute "Migrating files..." do
      command %{
        set -e
        rsync #{new_resource.rsync_options} #{remote}:#{new_resource.remote_path}/ #{new_resource.local_path}/
        chown -fR #{new_resource.owner}:#{new_resource._group} #{new_resource.local_path}
        touch #{migrate_lock}
      }
    end
  end
end

action :mysqldump do
  if migrate?
    if `ping -c 1 -W 1 #{new_resource.host}`.index(/1 (?:packets )?received/)
      execute "Migrating MySQL database..." do
        command  %{
          set -e
          ssh -t #{remote} sudo mysqldump --defaults-file=/root/.my.cnf #{new_resource.db_name} | bzip2 > #{db_dump}
        }
      end

      mysql_database new_resource.db_name do
        new_username new_resource.db_user
        new_password new_resource.db_password
        mysqldump db_dump
        action [:create_db, :create_user, :grant_privileges, :import]
      end

      if new_resource.db_dump_remove
        execute "Removing MySQL dump..." do
          command "rm #{db_dump}"
        end
      end
    else
      Chef::Log.error("MySQL migration: cannot reach #{new_resource.host}")
    end
  end
end

def migrate?
  !::File.exists?(migrate_lock) ||
  new_resource.force
end

def migrate_lock
  ::File.join(new_resource.local_path, "../.migrate.lock")
end

def db_dump
  ::File.join(new_resource.db_dump_path, "#{new_resource.db_name}.sql.bz2")
end

def remote
  [
    new_resource.user,
    "#{new_resource.host}"
  ].compact.join("@")
end
