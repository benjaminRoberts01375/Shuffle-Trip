import json
from .api import request_businesses
from .models import Account
from rest_framework import viewsets, permissions
from rest_framework.views import APIView
from rest_framework.response import Response
from .serializer import AccountSerializer


class AccountViewSet(viewsets.ModelViewSet):
    queryset = Account.objects.all()
    permission_classes = [
        permissions.IsAuthenticated
    ]
    serializer_class = AccountSerializer

class APIData(APIView):
    def get(self, request, format=None):
        print(json.loads(request.body))
        return Response(request_businesses(json.loads(request.body)))