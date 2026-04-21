project('ControlPanel',['cpp'], default_options: ['cpp_std=c++17'])

qt6 = import('qt6')
qrc_files = qt6.compile_resources(sources:'resources.qrc')

subdir('src')

install_data('com.slimbook.controlpanel.conf', install_dir:'share/dbus-1/system.d/')
install_data('com.slimbook.controlpanel.service', install_dir:'share/dbus-1/system-services/')
install_data('com.slimbook.controlpanel.desktop', install_dir:'share/applications/')
install_data('images/slimbook-controlpanel.svg', install_dir:'share/icons/hicolor/scalable/apps/')
