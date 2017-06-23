simpler-component-repository:
    builder.git_latest:
        - name: git@github.com:code56/nodeServerSimpleFig.git
        - identity: {{ pillar.elife.projects_builder.key or '' }}
       # - rev: branch_for_vagrant
        - target: /srv/simpler-component/
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

#need to add an if statement, where this command only runs the first time the machine is provisioned
npm-install:
    cmd.run:
        - name: sudo npm install
        - cwd: /srv/simpler-component/node_web_server/
        - user: {{ pillar.elife.deploy_user.username }}
        - require:
            - simpler-component-repository

simpler-component-database:
    mysql_database.present:
        - name: {{ pillar.simpler-component.db.name}}
        - connection_pass: {{pillar.elife.db_root.password}}
        - require:
        - mysql-ready

