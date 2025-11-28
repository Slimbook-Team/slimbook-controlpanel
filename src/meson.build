
qt6_dep = dependency('qt6', modules: ['Core', 'Gui','Widgets', 'Quick','DBus'])
moc_files = qt6.compile_moc(headers : ['bridge.hpp'], dependencies: qt6_dep)


compiler = meson.get_compiler('cpp')
libslimbook = compiler.find_library('slimbook')

executable('slimbook-controlpanel', [qrc_files, moc_files, 'bridge.cpp','common.cpp','controlpanel.cpp'], dependencies: [qt6_dep, libslimbook])

moc_files = qt6.compile_moc(headers : ['server.hpp'], dependencies: qt6_dep)
executable('slimbook-controlpanel-server',[moc_files,'sensors.cpp','server.cpp','common.cpp','controlpanel-server.cpp'],dependencies: [qt6_dep, libslimbook])

