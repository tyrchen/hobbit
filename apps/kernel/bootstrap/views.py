# -*- coding: utf-8 -*-
from __future__ import unicode_literals
import logging
from django.views.generic import TemplateView

__author__ = 'tchen'
logger = logging.getLogger(__name__)


class IndexView(TemplateView):
    template_name = 'bootstrap/index.html'
