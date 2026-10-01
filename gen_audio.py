import struct, wave, math, os

audio_dir = r'D:\Antigravity\Danish apps\medialog\assets\audio'
os.makedirs(audio_dir, exist_ok=True)

def make_sine_wav(filename, freq=440.0, duration=0.3, amplitude=0.4, sample_rate=44100, fade=True):
    n_samples = int(sample_rate * duration)
    data = []
    for i in range(n_samples):
        t = i / sample_rate
        sample = amplitude * math.sin(2 * math.pi * freq * t)
        if fade:
            env = 1.0 - (i / n_samples)
            sample *= env
        data.append(int(sample * 32767))
    with wave.open(filename, 'w') as wf:
        wf.setnchannels(1)
        wf.setsampwidth(2)
        wf.setframerate(sample_rate)
        wf.writeframes(struct.pack('<' + 'h' * len(data), *data))

def make_multi_tone_wav(filename, freqs, duration=0.5, amplitude=0.35, sample_rate=44100):
    n_samples = int(sample_rate * duration)
    step = n_samples // len(freqs)
    data = []
    for idx, freq in enumerate(freqs):
        start = idx * step
        seg_len = step if idx < len(freqs)-1 else n_samples - start
        for i in range(seg_len):
            t = i / sample_rate
            sample = amplitude * math.sin(2 * math.pi * freq * t)
            env = 1.0 - (i / seg_len)
            data.append(int(sample * env * 32767))
    with wave.open(filename, 'w') as wf:
        wf.setnchannels(1)
        wf.setsampwidth(2)
        wf.setframerate(sample_rate)
        wf.writeframes(struct.pack('<' + 'h' * len(data), *data))

def make_double_tick(filename, sample_rate=44100):
    n_s = int(sample_rate * 0.06)
    data = []
    for _ in range(2):
        for i in range(n_s):
            t = i / sample_rate
            s = 0.5 * math.sin(2 * math.pi * 1200 * t) * (1.0 - i/n_s)
            data.append(int(s * 32767))
        data.extend([0] * int(sample_rate * 0.04))
    with wave.open(filename, 'w') as wf:
        wf.setnchannels(1)
        wf.setsampwidth(2)
        wf.setframerate(sample_rate)
        wf.writeframes(struct.pack('<' + 'h' * len(data), *data))

make_sine_wav(os.path.join(audio_dir, 'ui_tick.wav'), freq=1200, duration=0.08, amplitude=0.5)
make_sine_wav(os.path.join(audio_dir, 'progress_pop.wav'), freq=800, duration=0.15, amplitude=0.6)
make_multi_tone_wav(os.path.join(audio_dir, 'completion_chime.wav'), [523, 659, 784, 1047], duration=1.0)
make_sine_wav(os.path.join(audio_dir, 'add_item.wav'), freq=600, duration=0.2, amplitude=0.45)
make_sine_wav(os.path.join(audio_dir, 'delete_item.wav'), freq=300, duration=0.25, amplitude=0.4)
make_multi_tone_wav(os.path.join(audio_dir, 'milestone.wav'), [392, 494, 587, 740], duration=0.8)
make_double_tick(os.path.join(audio_dir, 'swipe_action.wav'))
make_sine_wav(os.path.join(audio_dir, 'tab_switch.wav'), freq=900, duration=0.1, amplitude=0.35)

for f in sorted(os.listdir(audio_dir)):
    size = os.path.getsize(os.path.join(audio_dir, f))
    print(f'{f}: {size} bytes')
