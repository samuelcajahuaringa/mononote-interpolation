from . import QUOTES, COMMON_SEPARATORS, UPDATE_FREQUENCY, \
    MAX_ERROR_PRINTOUT

# =================================================
#      Automatically Reading Structured Arrays     
# =================================================

# Return the type of a string (try converting to int and float)
def get_type(obj):
    # Special case for handling empty strings (default to base type, int).
    if (hasattr(obj, "__len__") and (len(obj) == 0)):
        return int
    # Detect type by tring to cast and seeing what works.
    try:
        int(obj)
        return int
    except ValueError:
        try:
            float(obj)
            return float
        except ValueError:
            return str

# Remove nested separators inside of quotes in the line
def remove_quoted_content(line):
    cleaned_line = ""
    in_quotes = ""
    for char in line:
        # Toggle 'inside' quotes.
        if (len(in_quotes) == 0) and (char in QUOTES):
            in_quotes = char
        elif (char == in_quotes):
            in_quotes = ""
        elif (len(in_quotes) == 0):
            cleaned_line += char
    return cleaned_line

# Remove nested separators inside of quotes in the line
def split_with_quotes(line, sep):
    split_line = []
    cleaned_line = ""
    in_quotes = ""
    for char in line:
        # Toggle 'inside' quotes.
        if (char == in_quotes):
            in_quotes = ""
            if (char in cleaned_line): cleaned_line += char
        elif (len(in_quotes) == 0) and (char in QUOTES):
            in_quotes = char
            if (len(cleaned_line) > 0): cleaned_line += char
        elif (len(in_quotes) == 0) and (char == sep):
            split_line.append(cleaned_line)
            cleaned_line = ""
        else:
            cleaned_line += char
    # Append the last chunk of the line to the split.
    split_line.append(cleaned_line)
    return split_line

# Pre:  "filename" is the name of an existing file (including path)
# Post: "filename" is scanned for viable separators, those are all
#       characters used the same number of times on each line. If at
#       the end of the file there are still multiple candidate
#       separators, they are sorted by most-occuring first. If one of
#       COMMON_SEPARATORS exist in the set, it is used, otherwise the
#       most occurring separator is used.
def detect_separator(filename="<no_provided_file>", verbose=False, opened_file=None):
    import time
    from util.system import AtomicOpen
    lines = []
    if not opened_file: f = AtomicOpen(filename).file
    else:               f = opened_file
    # Identify the potential separators from the first line
    first_line = remove_quoted_content(f.readline())
    separators = {char:first_line.count(char) for char in set(first_line)}
    # Update the user
    last_update = 0
    should_update = lambda: (verbose and ((time.time() - last_update) > UPDATE_FREQUENCY))
    raw_data = f.readlines()
    # Cycle the file (narrowing down the list of potential separators
    for i,line in enumerate(raw_data):
        # Skip empty lines.
        if (len(line.strip()) == 0): continue
        # Update the user on progress if appropriate
        if should_update():
            last_update = time.time()
            print(f"\r{(100.0*i/len(raw_data)):0.1f}% complete", flush=True, end="")
        # Clean the line of quoted strings.
        line = remove_quoted_content(line)
        line_chars = set(line.strip())
        # Make sure all tracked separators appear the correct
        # number of times in the line
        for char in list(separators.keys()):
            if (line.count(char) != separators[char]):
                separators.pop( char )
        # WARNING: Do *not* break early, to verify that the
        #          separators are used correctly throughout the
        #          entire file!
    # Close the opened file object
    if not opened_file: f.close()
    # Go back to the beginning of the file
    else:               f.seek(0)
    # Get the separators from the dictionary sorted by the decreasing
    # number of occurrences the character has on each line of the data.
    separators = sorted(separators.keys(), key=lambda k: -separators[k])
    # Check to make sure there is a separator detected
    if len(separators) == 0:
        raise(Exception("ERROR: No consistently used separator in file."))
    if verbose:
        print(" Detected the following possible separators:\n  ", separators)
    # Search through the common separators first, using one of them if possible
    for sep in COMMON_SEPARATORS:
        if sep in separators:
            if verbose: print(" Using '%s' as separator."%sep)
            break
    else:
        # Otherwise, use the most occurring character that could be a separator
        sep = separators[0]
        print("WARNING: Using '%s' as a separator, even though it is unexpected."%(sep))
    # Return the automatically detected separator
    return sep

# Pre:  "filename" is the name of a txt file that has a header
#       "sep" is the separator used in the data file
#       "display" is True if the user wants the detected types printed
# Post: A data.Data class containing all data from the file.
def read_data(filename="<no_provided_file>", sep=None, types=None,
              verbose=False, opened_file=None, sample=None):
    import time
    from util.system import AtomicOpen
    from util.data.data import Data
    if sep == None: sep = detect_separator(filename, verbose, opened_file)
    # Get the opened file object
    if (not opened_file):
        # Open the file to get the data
        f = AtomicOpen(filename).file
    else:
        f = opened_file
        file_name = f.name
    # Get the first line, assuming it's the header
    header = [n.strip() for n in split_with_quotes(f.readline().strip(),sep)]
    # Get the first line of data and learn the types of each column
    line = [v.strip() for v in split_with_quotes(f.readline().strip(), sep)]
    # Automatically detect types (if necessary)
    type_digression = False
    if type(types) == type(None):
        types = list(map(get_type, line))
        type_digression = True
    # Initialize our data holder
    data = Data(names=header, types=types)
    # Add the first line to the data store (after inserting "None")
    while "" in line: line[line.index("")] = None
    data.append(line)
    # Get the rest of the raw data from the file and close it
    raw_data = f.readlines()
    if (not opened_file):
        # Close the file
        f.close()
    # WARNING: Provided file object left to be closed by caller
    # Print out a nicely formatted description of the detected types
    if verbose:
        print("Column names and types:")
        first_line  = ""
        second_line = ""
        for h,t in zip(header,types):
            length = max(len(h), len(t.__name__))
            first_line += f"  {h:{length}s}"
            second_line += f"  {t.__name__:{length}s}"
        print(first_line)
        print(second_line)
    # Now process the rest of the data, dynamically overwriting old data
    errors = []
    last_update = 0
    should_update = lambda: (verbose and ((time.time() - last_update) > UPDATE_FREQUENCY))
    # Define an appropriate iterator based on the usage of this "read".
    if sample:
        from util.random import random_range
        iterator = ((i, raw_data[i]) for i in sorted(random_range(len(raw_data), count=sample)))
    else: iterator = enumerate(raw_data)
    # Cycle through the elements of "raw_data".
    for i,line in iterator:
        # Update the user on progress if appropriate
        if should_update():
            last_update = time.time()
            print("\r%0.1f%% complete"% (100.0*i/len(raw_data)), flush=True, end="")
        # Clean up the line (in case there are nested separators)
        line = line.strip()
        # Read the line of data into a list format (replace empty string with None)
        # Remove leading and trailing quotes from strings if necessary
        list_line = [el.strip() for el in split_with_quotes(line, sep)]
        # Replace any empty strings with "None" for missing values
        while "" in list_line: list_line[list_line.index("")] = None
        # Try and add the line of data
        try:
            data.append(list_line)
        except Data.BadValue:
            if type_digression:
                # Update the types based on digression order
                list_line = [el.strip() for el in split_with_quotes(line, sep)]
                new_types = list(map(get_type, list_line))
                type_order = {int:0, float:1, str:2}
                new_types = [max(old,new, key=lambda v: type_order[v])
                             for (old,new) in zip(types, new_types)]
                # Update the user if appropriate
                if verbose:
                    print(f"\nType digression because of line {i+3}."+
                          f"\n  old types: {types}"+
                          f"\n  new types: {new_types}")
                # Retype the existing data to match the new types
                data.retype(new_types)
                # Append line that matches new types
                data.append(list_line)
                types = new_types
            else:
                errors.append(i+3)
                if len(errors) <= MAX_ERROR_PRINTOUT:
                    print(f"\nERROR ON LINE {i+3}:\n  {line}")
                if len(errors) == MAX_ERROR_PRINTOUT:
                    print("Suppressing further error output. See all erroneous lines in later message.")
    if verbose and (last_update != 0): print("\r100.0% complete.")
    if (len(errors) > 0) and (not verbose):
        print( "WARNING: Encountered potentially erroneous lines while\n"+
              f"         reading '{filename}'.\n"+
               "         Consider setting 'verbose=True' and checking errors.")
    if verbose and (len(errors) > MAX_ERROR_PRINTOUT):
        print(f"ERRONEOUS LINES FROM DATA:\n  {errors}")
    # Return the data
    return data
