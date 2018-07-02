from PIL import Image
import numpy as np
test_prefix = "testdata/"
test_name = "list.txt"
W, H = 120, 80

def LoadImages():
	ret = list()
	with open(test_prefix + test_name) as fp:
		for n, line in enumerate(fp.readlines()):
			s = line.split()
			arr = np.array(Image.open(test_prefix + s[0]))
			tag = int(s[1])
			assert arr.shape == (H, W, 3) and arr.dtype == np.uint8
			ret.append((arr, tag))
	return ret

def ComputeImages(imgs):
	ret = list()
	for img, tag in imgs:
		rg = img[:,:,0] >= img[:,:,1]
		rb = img[:,:,0] >= img[:,:,2]
		gb = img[:,:,1] >= img[:,:,2]
		r = np.logical_and(rg, rb)
		g = np.logical_and(gb, np.logical_not(rg))
		b = np.logical_and(np.logical_not(rb), np.logical_not(gb))
		r_n = np.count_nonzero(r)
		g_n = np.count_nonzero(g)
		b_n = np.count_nonzero(b)
		assert r_n + g_n + b_n == W*H
		r_intensity = np.sum(img[r,0], dtype=np.uint32)
		g_intensity = np.sum(img[g,1], dtype=np.uint32)
		b_intensity = np.sum(img[b,2], dtype=np.uint32)
		if r_n >= g_n and r_n >= b_n:
			img_type = 0
			img_n = r_n
			img_intensity = r_intensity
		elif g_n >= b_n:
			img_type = 1
			img_n = g_n
			img_intensity = g_intensity
		else:
			img_type = 2
			img_n = b_n
			img_intensity = b_intensity
		ret.append((img_type, img_intensity / img_n, img_n, img_intensity, tag))
	return ret

def SortFeatures(features):
	features.sort()
	return [(x[0], x[4]) for x in features]

if __name__ == "__main__":
	imgs = LoadImages()
	features = ComputeImages(imgs)
	for itype, itag in SortFeatures(features):
		print(f"Image type {itype}, image tag {itag}")
