from django.db import models

# Create your models here.
class Account(models.Model):
    name = models.CharField(max_length=20)
    type = models.CharField(max_length=20)
    created_at = models.DateTimeField(auto_now_add=True)
    def __str__(self):
        return self.name