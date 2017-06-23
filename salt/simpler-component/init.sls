simpler-component-repository:
    builder.git_latest:
        - name: git@github.com:code56/nodeServerSimplerFig.git
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

