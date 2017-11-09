#!/usr/bin/env python3

""" Script used to tabify a file - replace group of spaces with a tab """

import shutil
import os
import re
import sys
# import argparse

re_line_beginning = re.compile(r'^[ \t]+')
re_spaces = re.compile(r'^[ ]')
TAB = '\t'
SPACE = ' '


def get_line_beginning(line):
	""" return the beginning of the line (just spaces and tabs) """
	re_res = re_line_beginning.search(line)
	if re_res:
		return line[:re_res.span()[1]]
	else:
		return None


def is_spaced(line):
	""" returns True if the line uses spaces for indentation """
	beginning = get_line_beginning(line)
	if beginning is not None:
		return SPACE in beginning


def tabify(line, tabify_num):
	""" tabify a line - replace n-spaces with a TAB """
	beginning = get_line_beginning(line)
	num_of_spaces = 0
	
	spaceless_line = line[len(beginning):]
	for char in beginning:
		if char == SPACE:
			num_of_spaces += 1
		else:
			spaceless_line = char + spaceless_line
	
	tabs = int(num_of_spaces / tabify_num)
	
	for _ in range(0, tabs):
		spaceless_line = '\t' + spaceless_line

	return spaceless_line


def process_file(filename, shiftwidth):
	buffer = []
	temp_name = filename + '.tabify'
	# create backup copy of file before tabifying
	shutil.copyfile(filename, temp_name)
	try:
		with open(filename, 'r') as in_file:
			for line in in_file:
				if not is_spaced(line):
					buffer.append(line)
				else:
					tabified_line = tabify(line, shiftwidth)
					buffer.append(tabified_line)

		with open(filename, 'w') as out_file:
			out_file.write(''.join(buffer))

	except Exception as ex:
		print("Error occured ({!s}). Don't worry - will just restore the old file...".format(ex))
		shutil.copyfile(temp_name, filename)

	os.remove(temp_name)


def print_help():
	print("Usage: files shiftwidth".format(sys.argv[0]))


if __name__ == '__main__':
	# parser = argparse.ArgumentParser()
	# parser.add_argument("filename", help="path to file to tabify", type=str)
	# parser.add_argument("shiftwidth", help="so many spaces will be merged into a TAB", type=int)
	# args = parser.parse_args()

	files = []
	shiftwidth = None
	if len(sys.argv) < 3:
		print_help()
		sys.exit(1)
	else:
		files = sys.argv[1:len(sys.argv) - 1]
		try:
			shiftwidth = int(sys.argv[-1])
		except ValueError as ex:
			print("last argument has to be an integer")
			sys.exit(2)

	for fl in files:
		process_file(fl, shiftwidth)

	print("DONE")

# vim: tabstop=4 shiftwidth=4 noexpandtab ft=python
