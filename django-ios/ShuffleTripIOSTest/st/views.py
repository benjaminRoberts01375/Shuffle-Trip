from .models import Account
from rest_framework import viewsets, permissions
from .serializer import AccountSerializer

class AccountViewSet(viewsets.ModelViewSet):
    queryset = Account.objects.all()
    permission_classes = [
        permissions.IsAuthenticated
    ]
    serializer_class = AccountSerializer