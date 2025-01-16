#!/usr/bin/env python3
# Automatically generate/update gettext files for
# Localization files in the ./locales/[language]/ folder
# python parallel version of the script
# Prerequisite: pip install mdpo

import glob
import multiprocessing
from pathlib import Path
import time
import mdpo.md2po as md2po


def process_file(args):
    md_file_path, po_file_path = args
    md2po.markdown_to_pofile(md_file_path,
                             po_filepath = po_file_path,
                             md_encoding='utf-8',
                             po_encoding='utf-8',
                             wrapwidth=80,
                             save=True,
                             metadata={'Content-Type':'text/plain; charset=UTF-8'}
                             )


def main():
    start_time = time.time()
    # Get a list of locale directories
    locale_dirs = [d.name for d in Path('docs/locales').iterdir() if d.is_dir()]

    # Get a list of English Markdown files
    md_files = [Path(f).name for f in glob.glob('docs/*.md')]
    # Generate md file paths
    md_file_paths = {}
    for md_file in md_files:
        md_file_paths[md_file] = f"docs/{md_file}"

    # Create a pool of workers
    num_cpus = multiprocessing.cpu_count()
    pool = multiprocessing.Pool(processes=num_cpus)

    for dir in locale_dirs:
        print(f"Updating {dir}")
        # Generate po file paths
        po_file_paths = {}
        file_suffix = '.pot' if dir == 'en' else '.po'
        for md_file in md_files:
            po_file = md_file.replace('.md', file_suffix)
            po_file_paths[md_file] =  f"docs/locales/{dir}/LC_MESSAGES/{po_file}"

        #for md_file in md_files:
        #    process_file((md_file_paths[md_file], po_file_paths[md_file]))
        # Create a list of (dir, mdfile) tuples for all files
        tasks = [(md_file_paths[md_file], po_file_paths[md_file]) for md_file in md_files]

        # Process files in parallel
        pool.map(process_file, tasks)

    pool.close()
    pool.join()
    print("--- %s seconds ---" % (time.time() - start_time))


if __name__ == '__main__':
    main()