# allow load libstdc++.so.X.X.X-gdb.py from Linuxbrew gcc
add-auto-load-safe-path ~/usr/opt/gcc/lib/

# == read XDG dirs ==
python
import os
config_dir = os.environ.get('XDG_CONFIG_HOME', os.path.join(os.environ['HOME'], '.config'))
config_dir = os.path.join(config_dir, 'gdb')
cache_dir = os.environ.get('XDG_CACHE_HOME', os.path.join(os.environ['HOME'], '.cache'))
cache_dir = os.path.join(cache_dir, 'gdb')
if not os.path.exists(cache_dir):
    os.makedirs(cache_dir)
end

# == history configure ==
python gdb.execute('set history filename ' + os.path.join(cache_dir, 'history'))
set history remove-duplicates 100
set history size 10000

# == gdb-dashboard configure ==
python
import subprocess
dashboard_dir = os.path.join(config_dir, 'dashboard')
dashboard_init = os.path.join(dashboard_dir, '.gdbinit')
if not os.path.exists(dashboard_init):
    subprocess.call(['git', 'clone', 'https://github.com/cyrus-and/gdb-dashboard', dashboard_dir])
gdb.execute('source ' + dashboard_init)
end

# custom stack command
# https://github.com/cyrus-and/gdb-dashboard/issues/28
define stack
python
stack = Stack()
stack.limit = 0
stack.show_arguments = True
stack.show_locals = True
stack.compact = True
print('\n'.join(stack.lines(Dashboard.get_term_width(), False)))
end
end

# set layout (hide assembly registers memory threads)
dashboard -layout source expressions history stack
