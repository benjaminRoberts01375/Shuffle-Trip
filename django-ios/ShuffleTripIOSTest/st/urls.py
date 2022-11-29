from django.urls import path, include
from . import views
from rest_framework import routers

router = routers.DefaultRouter()
router.register('accounts', views.AccountViewSet)

urlpatterns = [
    path('', include(router.urls), name='accounts'),
    path('api-auth/', include('rest_framework.urls', namespace='rest_framework'))
]