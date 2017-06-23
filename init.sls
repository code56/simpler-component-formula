simpler-component-repository:
    builder.git_latest:
        - name: git@github.com:code56/node_web_server.git
        #- branch: branch_for_vagrant
        - identity: {{ pillar.elife.projects_builder.key or '' }}
        - rev: branch_for_vagrant
        - target: /srv/node-web-server/
        - branch: {{ salt['elife.branch']() }}
        - force_fetch: True
        - force_checkout: True
        - force_reset: True
        - fetch_pull_requests: True

    file.directory:
        - name: /srv/simpler-component
        - user: {{ pillar.elife.deploy_user.username }}
        - group: {{ pillar.elife.deploy_user.username }}
        - recurse: 
            - user
            - group
        - require:
            - builder: simpler-component-repository


#added these 3 lines need to test them to see if they are working
npm-install:
    cmd.run:
        - name: sudo npm install
        - cwd: /srv/simpler-component/
        - user: {{ pillar.elife.deploy_user.username }}
        - require:
            - simpler-component-repository
    

simpler-component-database:
    mysql_database.present:
        - name: {{ pillar.simpler-component.db.name}}
        - connection_pass: {{pillar.elife.db_root.password}}
        - require:
            - mysql-ready


simpler-component-database-user:
    mysql_user.present:
        - name: {{ pillar.simpler-component.db.user }}
        - password: {{ pillar.simpler-component.db.password }}
        - connection_pass: {{ pillar.elife.db_root.password }}
        {% if pillar.elife.env in ['dev'] %}
        - host: '%'
        {% else %}
        - host: localhost
        {% endif %}
        - use:
            mysql_database: simpler-component-database
        - require:
            - mysql-ready


#any references to pillar, cannot have -, needs to be underscore
simpler-component-database-access:
    mysql_grants.present:
        - user: {{ pillar.simpler-component.db.user }}
        - connection_pass: {{ pillar.elife.db_root.password }}
        - database: {{ pillar.simpler-component.db.name }}.*
        - grant: all privileges
        {% if pillar.elife.env in ['dev'] %}
        - host: '%'
        {% else %}
        - host: localhost
        {% endif %}
        - require:
            - simpler-component-database
            - simpler-component-database-user


# only run the bash file with the rake commands to populate 
# the mysql database if it wasn't run before

# testing to run a shell script

#Run testing_bash.sh:
#    cmd.run:
 #       - name: sudo bash testing_bash.sh
  #      - cwd: /srv/node-web-server/public/assets/bash/
  #      - stateful: False


# to download the expvip-web-server of Ricardo Ramirez code, so that the
# commands for running the server, and for populating the tables will be 
# working 


# to load the required gems, run "bundle install"
dependencies-install:
    cmd.run:
        - name: sudo apt-get install build-essential patch 
        - cwd: /srv/expvip-server/
        - user: {{ pillar.elife.deploy_user.username }}
        - require:
            - expvip-server-repository
            - expvip-server-deb-dependencies
            - ruby

# && sudo gem install rubygems-update && sudo gem install activesupport -v '5.0.1' && sudo gem install nokogiri -v '1.6.7.2' && sudo bundle install 


#download files from Dropbox:



