@setlocal enableextensions & cls & python -x "%~f0" %* & goto :EOF

import sys
import re


def usage(prog):
    # print "%s <inputfile> <pattern> [reversed]" % prog
    print "%s <pattern> [Reverse]" % prog


def win32_unicode_argv():
    """Uses shell32.GetCommandLineArgvW to get sys.argv as a list of Unicode
    strings.

    Versions 2.x of Python don't support Unicode in sys.argv on
    Windows, with the underlying Windows API instead replacing multi-byte
    characters with '?'.
    """

    from ctypes import POINTER, byref, cdll, c_int, windll
    from ctypes.wintypes import LPCWSTR, LPWSTR

    GetCommandLineW = cdll.kernel32.GetCommandLineW
    GetCommandLineW.argtypes = []
    GetCommandLineW.restype = LPCWSTR

    CommandLineToArgvW = windll.shell32.CommandLineToArgvW
    CommandLineToArgvW.argtypes = [LPCWSTR, POINTER(c_int)]
    CommandLineToArgvW.restype = POINTER(LPWSTR)

    cmd = GetCommandLineW()
    argc = c_int(0)
    argv = CommandLineToArgvW(cmd, byref(argc))
    if argc.value > 0:
        # Remove Python executable and commands if present
        start = argc.value - len(sys.argv)
        return [argv[i] for i in
                xrange(start, argc.value)]


def parselineToKey(line, pat):
	m = re.search(pat, line)
	if m: return m.group(0)


def parsefileToarray(f,pat):
	dict = {}
	for line in f:
		# print line
		key = parselineToKey(line,pat)
		if key and key not in dict: dict[key]=line
	# print dict.keys()
	return dict


def outputSorted(dict, rev):
	# print sorted(dict.keys())
	for key in sorted(dict.keys(),reverse=rev):
		print dict[key],


def main():
	sys.argv = win32_unicode_argv()
	if len(sys.argv) < 1:
		usage(sys.argv[0])
		return

	pattern="\(.*\)"
	pattern=sys.argv[1]
	# inputfile=sys.argv[2]
	reverse = False
	if len(sys.argv) >= 3:
		reverse = (sys.argv[2]=="Reverse")
	
	# print "reverse",reverse
	
	# f=open(inputfile, 'r')
	f=sys.stdin
	outarray=parsefileToarray(f,pattern)
	
	print "" #output a dummy line
	
	outputSorted(outarray,reverse)
	
	# print len(sys.argv)
	# print sys.argv
	# raw_input()


if __name__ == '__main__':
	main()