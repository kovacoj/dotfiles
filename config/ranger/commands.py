from __future__ import absolute_import, division, print_function

import os

from ranger.api.commands import Command


class code_here(Command):
    """:code_here

    Open VS Code in the selected directory, or in the current directory if the
    current selection is a file.
    """

    def execute(self):
        current = self.fm.thisfile
        cwd = self.fm.thisdir.path if self.fm.thisdir else None

        if current and current.is_directory:
            target = current.path
        elif current:
            target = os.path.dirname(current.path)
        else:
            target = cwd

        if not target:
            self.fm.notify('No directory available for VS Code', bad=True)
            return

        self.fm.execute_command(['code', target], flags='f')
