from django.conf.urls import patterns, include, url

from django.contrib import admin
from apps.kernel.bootstrap.views import IndexView

admin.autodiscover()

urlpatterns = patterns('',
                       url('^$', IndexView.as_view(), name="home"),
                       url(r'^admin/', include(admin.site.urls)),
                       )
