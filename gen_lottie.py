import json, os

lottie_dir = r'D:\Antigravity\Danish apps\medialog\assets\lottie'
os.makedirs(lottie_dir, exist_ok=True)

def make_lottie(name, desc, color, shape='circle'):
    r = int(color[1:3], 16) / 255
    g = int(color[3:5], 16) / 255
    b = int(color[5:7], 16) / 255
    if shape == 'circle':
        shapes = [{'ty': 'el', 's': {'a': 0, 'k': [80, 80]}, 'p': {'a': 0, 'k': [0, 0]}, 'nm': 'Circle'}]
    elif shape == 'star':
        shapes = [{'ty': 'sr', 'sy': 1, 'd': 1, 'pt': {'a': 0, 'k': 5}, 'p': {'a': 0, 'k': [0, 0]},
                   'r': {'a': 0, 'k': 0}, 'ir': {'a': 0, 'k': 30}, 'or': {'a': 0, 'k': 60},
                   'is': {'a': 0, 'k': 0}, 'os': {'a': 0, 'k': 0}, 'nm': 'Star'}]
    else:
        shapes = [{'ty': 'rc', 's': {'a': 0, 'k': [80, 80]}, 'p': {'a': 0, 'k': [0, 0]}, 'r': {'a': 0, 'k': 12}, 'nm': 'Rect'}]

    lottie = {
        'v': '5.9.0',
        'fr': 30,
        'ip': 0,
        'op': 90,
        'w': 300,
        'h': 300,
        'nm': desc,
        'ddd': 0,
        'assets': [],
        'layers': [
            {
                'ddd': 0,
                'ind': 1,
                'ty': 4,
                'nm': 'Shape Layer',
                'sr': 1,
                'ks': {
                    'o': {'a': 1, 'k': [
                        {'i': {'x': [0.833], 'y': [0.833]}, 'o': {'x': [0.167], 'y': [0.167]}, 't': 0, 's': [0]},
                        {'i': {'x': [0.833], 'y': [0.833]}, 'o': {'x': [0.167], 'y': [0.167]}, 't': 30, 's': [100]},
                        {'t': 90, 's': [0]}
                    ]},
                    'r': {'a': 1, 'k': [
                        {'i': {'x': [0.833], 'y': [0.833]}, 'o': {'x': [0.167], 'y': [0.167]}, 't': 0, 's': [0]},
                        {'t': 90, 's': [360]}
                    ]},
                    'p': {'a': 0, 'k': [150, 150, 0]},
                    'a': {'a': 0, 'k': [0, 0, 0]},
                    's': {'a': 1, 'k': [
                        {'i': {'x': [0.667, 0.667, 0.667], 'y': [1, 1, 1]}, 'o': {'x': [0.333, 0.333, 0.333], 'y': [0, 0, 0]}, 't': 0, 's': [0, 0, 100]},
                        {'i': {'x': [0.667, 0.667, 0.667], 'y': [1, 1, 1]}, 'o': {'x': [0.333, 0.333, 0.333], 'y': [0, 0, 0]}, 't': 30, 's': [100, 100, 100]},
                        {'t': 90, 's': [80, 80, 100]}
                    ]}
                },
                'ao': 0,
                'shapes': [
                    {
                        'ty': 'gr',
                        'it': shapes + [
                            {'ty': 'fl', 'c': {'a': 0, 'k': [r, g, b, 1]}, 'o': {'a': 0, 'k': 100}, 'nm': 'Fill'},
                            {'ty': 'tr', 'p': {'a': 0, 'k': [0, 0]}, 'a': {'a': 0, 'k': [0, 0]},
                             's': {'a': 0, 'k': [100, 100]}, 'r': {'a': 0, 'k': 0}, 'o': {'a': 0, 'k': 100}}
                        ],
                        'nm': 'Group'
                    }
                ],
                'ip': 0,
                'op': 90,
                'st': 0
            }
        ]
    }
    path = os.path.join(lottie_dir, name)
    with open(path, 'w') as f:
        json.dump(lottie, f, separators=(',', ':'))
    print(f'Written: {name} ({os.path.getsize(path)} bytes)')

make_lottie('empty_library.json',   'Empty Library State',       '#8B5CF6', 'circle')
make_lottie('empty_active.json',    'No Active Items',           '#6366F1', 'rect')
make_lottie('completion_burst.json','Completion Celebration',    '#F59E0B', 'star')
make_lottie('milestone_star.json',  'Milestone Achievement',     '#10B981', 'star')
make_lottie('progress_ring.json',   'Progress Animation',        '#3B82F6', 'circle')
make_lottie('add_success.json',     'Add Item Success',          '#8B5CF6', 'circle')
print('All lottie files created')
