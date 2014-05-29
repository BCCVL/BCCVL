# Bootstrap the Sentry environment
from sentry.utils.runner import configure
configure()

# Do something crazy
from sentry.models import Team, Project, ProjectKey, User


if not User.objects.filter(username='admin'):
    admin = User(username='admin',
                 email='admin@localhost',
                 is_superuser=True)
    admin.set_password('admin')
    admin.save()
admin = User.objects.get(username='admin')

for name in ('bccvl', 'bccvl-qa', 'bccvl-dev'):
    if not Team.objecs.filter(name=name):
        team = Team(name=name,
                    owner=admin)
        team.save()
    if not Project.objects.filter(name=name):
        project = Project(name=name,
                          owner=admin,
                          team=team)
        project.save()


#key = ProjectKey.objects.filter(project=project)[0]
#print 'SENTRY_DSN = "%s"' % (key.get_dsn(),)
