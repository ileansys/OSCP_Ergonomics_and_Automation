#!/usr/bin/python
# Take2 by Andrew Abwoga <andrew.abwoga@gmail.com>
# GPL v2 only
# How to setup. Just do this ---> sudo cp /usr/lib/python3.8/site-packages/terminatorlib/plugins/
"""take2.py - Take2 Plugin to take 'screenshots' of individual
terminals and store them in the present working directory"""

import os
from gi.repository import Gtk
from gi.repository import GdkPixbuf 
import inspect
import terminatorlib.plugin as plugin
from terminatorlib.translation import _
from terminatorlib.util import widget_pixbuf
from datetime import datetime

# Every plugin you want Take2 to load *must* be listed in 'AVAILABLE'
AVAILABLE = ['Take2']

class Take2(plugin.MenuItem):
    """Add custom commands to the terminal menu"""
    capabilities = ['terminal_menu']

    def __init__(self):
        plugin.MenuItem.__init__(self)
        self.plugin_name = self.__class__.__name__

    def callback(self, menuitems, menu, terminal):
        """Add our menu items to the menu"""
        item = Gtk.MenuItem.new_with_mnemonic(_('Take2'))
        item.connect("activate", self.take2, terminal)
        menuitems.append(item)

    def get_terminal(self):
        # HACK: Because the current working directory is not available to
        # plugins, we need to use the inspect module to climb up the stack to
        # the Terminal object and call get_cwd() from there.
        for frameinfo in inspect.stack():
            frameobj = frameinfo[0].f_locals.get('terminal')
            if frameobj and frameobj.__class__.__name__ == 'Terminal':
                return frameobj

    def get_cwd(self):
        """ Return current working directory. """
        term = self.get_terminal()
        if term:
            return term.get_cwd()

    def take2(self, _widget, terminal):
        """Handle the taking and saving of a screenshot"""
        orig_pixbuf = widget_pixbuf(terminal)
        pixbuf = orig_pixbuf.scale_simple(orig_pixbuf.get_width() / 2, 
                                     orig_pixbuf.get_height() / 2,
                                     GdkPixbuf.InterpType.BILINEAR)
        image = Gtk.Image.new_from_pixbuf(pixbuf)
        now = datetime.now()
        rightnow = now.strftime("%d-%m-%Y %H:%M:%S")
        print(self.get_cwd())
        path = os.path.join(self.get_cwd(), rightnow)
        orig_pixbuf.savev(path, 'png', [], [])