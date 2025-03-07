import os, sys
from .read import read_data
from .categories import regular_simplex
from . import DEFAULT_DISPLAY_WAIT, GENERATOR_TYPE, NP_TYPES, \
    SEPARATORS, FILE_SAMPLE_SIZE, MISSING_SAMPLE_SIZE

# TODO:  Make access of a single row (in slicing) return a Row object.
# TODO:  Make "save" and "load" to CSV support having iterables of
#        readable types. Expand them out to columns with particular
#        names (for compatibility with other software), read those
#        particular names back into a stack.
# TODO:  Make "to_matrix" automatically flatten elements of columns
#        that contain iterables into their base types. If the types
#        are numeric, use float, otherwise use string. Use "is numeric".
# TODO:  Make "to_matrix" automatically consider 'None' a unique value
#        for categorical columns and add a dimension 'is present' otherwise.
# TODO:  Wrap the necessary "Numeric" attributes into the matrix,
#        using a custom ndarray object from numpy.
# TODO:  Rewrite "predict" to work given a data object. This will
#        break up the data into collections of unique missing values.
#        Then for each collection, build a model over the appropriate
#        matrix-format data and predict that collection. This will
#        work more nicely with the k-fold method.
# TODO:  Remove the "fill" method in favor of "predict".
# TODO:  Make "predict" not require that target columns be convertible
#        to numeric form, only that they operate under a weighted sum.
# TODO:  Fix "type digression" message to say specifically what column
#        changed types and show the value that triggered the change.
# TODO:  Implement "parallel read" that create subprocesses that read
#        chunks of the file, communicate progress, communicate type
#        digressions, saves chunks in .pkl, then organizes them all
#        into the expected ordered data format.
# TODO:  Make printout shorter for data with lots of columns.
# TODO:  Implmenent 'IndexedAudio' reader that mimics the
#        'IndexedVideo' reader and allows for access to peaks.
# TODO:  Implemenet 'IndexedText' reader that mimics the
#        'IndexedVideo' reader and allows for access to characters.
# TODO:  Implement 'IndexedCSV' reader that reads rows out of a very
#        large CSV file.
# TODO:  Implement 'LazyData' whose underlying '.data' object is a
#        lazy-evaluated 'IndexedCSV' object.
# TODO:  Implement 'CachedData' whose underlying '.data' object caches
#        groups of rows to keep the memory footprint low.


# ======================================================
#      Python 'Data' with named and typed columns     
# ======================================================

# Return 'True' if an object is iterable.
def is_iterable(obj):
    try:    return (iter(obj) and True)
    except: return False

# Define a python data matrix structure (named and typed columns).
class Data:
    # Holder for data.
    data = None
    view = False
    # Boolean for declaring if this is a "view" or actual data.
    _row_indices = None
    _col_indices = None
    # Default maximum printed rows of this data.
    max_display = 10
    # Default maximum string length of printed column values.
    max_str_len = 50
    # Define the time waited before displaying progress.
    max_wait = DEFAULT_DISPLAY_WAIT
    # Define the maximum display width for a table (with many columns)
    # before the data is automatically displayed in different format.
    max_print_width = 100
    # Default values for 'self.names' and 'self.types'
    _names = None
    _types = None

    # Import all of the exceptions.
    from .exceptions import NameTypeMismatch, \
        BadSpecifiedType, BadSpecifiedName, NoNamesSpecified, \
        ImproperUsage, UnknownName, Unsupported, BadAssignment, \
        BadElement, BadTarget, BadValue, BadIndex, BadData, Empty, \
        MissingModule
    # Import the classes used to protect this data object.
    from .auxiliary import Descriptor, Column, Row

    # Protect the "names" and "types" attributes by using properties
    # to control the access and setting of these values.
    @property
    def names(self): return self._names
    @names.setter
    def names(self, values): self._names = Data.Descriptor(self, values)
    @property
    def types(self): return self._types
    @types.setter
    def types(self, values): self._types = Data.Descriptor(self, values)
    # Return True if empty.
    @property
    def empty(self): return ((self.names is None) or (self.types is None))
    # Declare the "start" property / function to re-initialized when called.
    @property
    def shape(self):
        if (self.empty):  return (0, 0)
        elif (self.view): return (len(self), len(self._col_indices))
        else:             return (len(self), len(self.names.values))

    # Declare a "summary" property that returns the results of
    # "summarize" as a string (instead of printing them to output).
    @property
    def summary(self):
        import tempfile
        with tempfile.TemporaryFile(mode="w+t") as f:
            self.summarize(file=f)
            f.seek(0)
            output = f.read()
        return output

    # Given an index, return the index in "self.data" that holds that row. 
    def row(self, idx):
        if self.view: return self._row_indices[idx]
        else:         return idx

    # Given an index, return the index in "self.data" that holds that row. 
    def col(self, idx):
        if self.view: return self._col_indices[idx]
        else:         return idx


    #      Overwritten list Methods     
    # ==================================

    def __init__(self, data=None, names=None, types=None, rows=None, cols=None):
        import time
        start = time.time()
        # Initialize the contents of this Data to be an empty list.
        self.data = []
        # Verify the length of the types and names
        if ((types is not None) and
            (names is not None) and
            (len(types) != len(names))):
            raise(Data.NameTypeMismatch(f"Length of provided names {len(names)} does not match length of provided types {len(types)}."))
        # Get the names (must be strings)
        if (names is not None):
            if any(type(n) != str for n in names):
                raise(Data.BadSpecifiedName(f"An entry of provided names was not of {str} class."))
            self.names = names
            # Construct default types for each column if names were not provided.
            if (types is None): types = [type(None)] * len(names)
        # Store the types if provided
        if (types is not None):
            if any(type(t) != type for t in types):
                raise(Data.BadSpecifiedType(f"An entry of provided types was not of {type(type)} class."))
            self.types  = types
            # Construct default names for each column if names were not provided.
            if (self.names is None): self.names = [str(i) for i in range(len(types))]
        # Check if this is a view or a full data object.
        self.view = ((rows is not None) or (cols is not None))
        # If this is a "view" object, store a pointer.
        if self.view:
            if (type(None) in map(type,(data,rows,cols))):
                raise(ImproperUsage("Data, column indices, and row indices must be provided for a view."))
            self.data = data
            self._row_indices = rows
            self._col_indices = cols
        # If provided, build this data as a deep copy of provided data.
        elif (data is not None):
            for i,row in enumerate(data):
                # Update user on progress if too much time has elapsed..
                if (time.time() - start) > self.max_wait:
                    print(f" {100.*row/len(data):.2f}% init", end="\r", flush=True)
                    start = time.time()
                self.append(row)

    # Overwrite the standard "[]" get operator to accept strings as well.
    # Given local-specific index, convert to Data index and return value.
    def __getitem__(self, index):
        # Special case for being empty.
        if (self.empty): raise(Data.Empty("Cannot get item from empty data."))
        # This index is accessing a (row,col) entry
        if ((type(index) == tuple) and (len(index) == 2) and 
            (type(index[0]) == int) and (type(index[1]) == int)):
            return self.data[self.row(index[0])][self.col(index[1])]
        elif ((type(index) == tuple) and (len(index) == 2) and 
              (type(index[0]) == int and type(index[1]) == str)):
            if (index[1] not in self.names):
                raise(Data.BadIndex(f"Column index {index[1]} is not a recognized column name."))
            # This index is accessing a (row,col) entry
            return self.data[self.row(index[0])][self.names.index(index[1])]
        elif (type(index) == int):
            if (self.view): return Data.Row(self, self.data[self.row(index)])
            else:           return self.data[index]
        elif (type(index) == str):
            # This index is accessing a column
            if (index not in self.names):
                raise(Data.UnknownName(f"This data does not have a column named '{index}'."))
            # If this is a view, make that numerical index relative to this.
            if (self.view):
                col_names = list(self.names)
                if index not in col_names:
                    raise(Data.UnknownName(f"This data does not have a column named '{index}'."))
                num_index = col_names.index(index)
            # Otherwise, retreive the exact numerical column index.
            else:
                num_index = self.names.index(index)
            # Return a mutable "Column" object
            return Data.Column(self, num_index)
        # Short-circuit for recognizing a column object.
        elif ((type(index) == tuple) and (len(index) == 2) and
              (type(index[0]) == slice) and (type(index[1]) in {int, str})):
            if (type(index[1]) == str):
                # This index is accessing a column
                if (index[1] not in self.names):
                    raise(Data.UnknownName(f"This data does not have a column named '{index[1]}'."))
                # If this is a view, make that numerical index relative to this.
                if (self.view):
                    col_names = list(self.names)
                    if index not in col_names:
                        raise(Data.UnknownName(f"This data does not have a column named '{index[1]}'."))
                    num_index = col_names.index(index[1])
                # Otherwise, retreive the exact numerical column index.
                else:
                    num_index = self.names.index(index)
            # Handle an integer index.
            elif (type(index[1]) == int):
                if (not (-self.shape[1] <= index[1] < self.shape[1])):
                    raise(Data.BadIndex(f"The integer column index {index[1]} is out of the valid range."))
                num_index = index[1]
            # Get the row indices.
            indices = list(range(len(self))[index[0]])
            # Return a mutable "Column" object
            return Data.Column(self, num_index, indices=indices)
        # If they are extracting the full data then assume a copy is desired.
        elif ((type(index) == slice) and (index == slice(None))):
            return self.copy()
        elif ((type(index) == tuple) and (len(index) == 2) and
              (type(index[0]) == slice) and (index[0] == slice(None)) and 
              (type(index[1]) == slice) and (index[1] == slice(None))):
            return self.copy()
        # Othwerwise this is a special index and we need to convert it.
        else:
            # This index is retrieving a sliced subset of self.
            rows, cols = self._index_to_rows_cols(index)
            # If this is only accessing a single row, return a Row object.
            if (type(index) == tuple) and (len(index) == 2) and (type(index[0]) == int): 
                return self.data[rows[0]][cols]
            # Otherwise make an alias data set (a data "view") and return it.
            return type(self)(data=self.data, names=self.names.values,
                        types=self.types.values, rows=rows, cols=cols)

    # Overwrite the standard "[]" get operator to accept strings as well.
    # Given local-specific index, convert to Data index and return value.
    def __setitem__(self, index, value):
        # Special case for being empty.
        if (self.empty): raise(Data.Empty("Cannot set item for empty data."))
        # Special case assignment of new column (*RETURN* to exit function).
        if ((type(index) == str) and (index not in self.names)):
            # Check to see if this is a data view object.
            if (self.view) and (len(self) != len(self.data)):
                raise(Data.Unsupported("This is a data alias and does not support assignment."))
            elif (self.view) and (index in self.names.values):
                raise(Data.ImproperUsage("This is a data view and the provided index conflicts with a column in the original data."))
            elif (self.view):
                raise(Data.Unsupported("\n  This is a view of a Data object.\n  Did you expect this new column to be added to the original data?"))
            # Check to see if the provided value was a singleton.
            singleton = (not is_iterable(value)) or (type(value) == str)
            if (not singleton):
                try:    singleton = len(value) != len(self)
                except: pass
            # If singleton was provided, set the whole column with that value.
            if singleton:
                v = value
                value = (v for i in range(len(self)))
            # Otherwise perform the normal column addition.
            return self.add_column(value, name=index)
        # Get the list of rows and list of columns being assigned.
        rows, cols = self._index_to_rows_cols(index)
        # ------------------------------------------------------------
        #    Determine whether a singleton was provided or not.
        # 
        # Assume if it has an iterator that is not a singleton.
        # Assume that if the value type matches all assigned types it is a singleton.
        singleton = (not is_iterable(value)) or \
                    (all(self.types[c] in {type(value), type(None)} for c in cols))
        # If it has a "length" then use that to verify singleton status.
        if singleton:
            try:    singleton = len(value) != (len(rows)*len(cols))
            except: pass
        # Assume if the "value" is a string, then this is a singleton.
        if (not singleton) and (type(value) == str): singleton = True
        # Assume if the value is a generator and the column(s) it is
        # assigning to are not *all* generators, it is not a singleton.
        if ((type(value) == GENERATOR_TYPE) and
            any(self.types[c] != GENERATOR_TYPE for c in cols)): singleton = False
        # ------------------------------------------------------------
        # Assume singleton status is correct.
        if (not singleton): value_iter = iter(value)
        # Reset type entirely if the new data assigns to the full column,
        # only if this data views the entire column.
        if (len(rows) == len(self.data)):
            for col in cols: self.types[col] = type(None)
        # Iterate over rows and perform assignment.
        for step, row in enumerate(rows):
            if type(row) != int:
                raise(Data.BadIndex(f"The provided row index of type {type(row)}, {row}, is not understood."))
            for col in cols:
                # Retreive next value from iterator if necessary.
                if not singleton:
                    try:    value = next(value_iter)
                    except: raise(Data.BadValue(f"Provided iterable only contained {step+1} elements, expected more."))
                # The existing column doesn't have a type, assign it.
                if (self.types[col] == type(None)):
                    self.types[col] = type(value)
                # Ignore missing values.
                elif (value is None): pass
                # Check against the existing column type (for verification).
                elif (type(value) != self.types[col]):
                    message = f"Provided value {value} of type {type(value)} does not match expected type {self.types[col]}."
                    if (self.view): message = "This Data is a view. " + message
                    raise(Data.BadAssignment(message))
                # Make the assignment
                self.data[row][col] = value
        # Verify that the iterable has been exhausted.
        if (not singleton):
            try:
                value = next(value_iter)
                raise(Data.BadAssignment(f"Column assignment requires a column of length {len(self)}, provided values iterable was too long."))
            except StopIteration: pass

    # Printout a brief table-format summary of this data.
    def __str__(self, short=False):
        # Special case for being empty.
        if (self.empty): return "This Data has no contents.\n"
        # Custom short string for a 'data' type object.
        if short: return f"Data ({self.shape[0]} x {self.shape[1]}) -- {self.names}"
        # Make a pretty table formatted output
        num_rows, num_cols = self.shape
        rows = []
        rows += [ list(self.names) ]
        rows += [ list(map(lambda t: str(t)[8:-2],self.types)) ]
        for i,row in enumerate(self):
            rows += [ row ]
            if i >= self.max_display: break
        # Redefine all rows by mapping them to strings.
        rows = rows[:2] + [list(map(self._val_to_str,r)) for r in rows[2:]]
        # Compute length of each row.
        lens = [max(len(r[c]) for r in rows)
                for c in range(num_cols)]
        # Redefine all rows by adding spaces to short-columns.
        rows = [[v + " "*(lens[i]-len(v)) for i,v in enumerate(row)]
                for row in rows]
        rows = [" " + (" | ".join(row)) + "\n" for row in rows]
        # Construct the strings for the "view" and "size" descriptions
        view_string = "This data is a view.\n" if self.view else ""
        size_string = f"Size: ({num_rows} x {num_cols})"
        # Construct the string describing missing values.
        missing_string = ""
        # For small data, the sample is everything.
        if len(self) < MISSING_SAMPLE_SIZE:
            sample = self
        # For larger data, use a sample of reasonably small size.
        else:
            from util.random import random_range
            sample = self[sorted(random_range(len(self),count=MISSING_SAMPLE_SIZE)),:]
        is_none = lambda v: (v is None)
        missing_rows = {r+1:sum(map(is_none,v)) for (r,v) in enumerate(sample) if (None in v)}
        # Print some info about missing values if they exist.
        if len(missing_rows) > 0:
            missing_cols = {c:sum(map(is_none,sample[n])) for (c,n) in enumerate(sample.names) if (None in sample[n])}
            # Get some statistics on the missing values.
            row_indices = sorted(missing_rows)
            col_indices = [sample.names[i] for i in sorted(missing_cols)]
            total_missing_values = sum(missing_rows.values())
            if (sample != self): total_missing_values *= round(len(self) / MISSING_SAMPLE_SIZE)
            total_values = num_rows * num_cols
            # Print out the indices of the rows with missing values
            # Add elipses if there are a lot of missing values.
            print_indices = ', '.join(map(str, row_indices[:self.max_display]))
            missing_string += f" missing {'estimated ' if (sample != self) else ''}{total_missing_values} of {total_values} entries,\n"
            missing_string += f"      at rows: [{print_indices}"
            if (len(row_indices) > self.max_display): missing_string += ", ..."
            missing_string += "]\n"
            # Repeat same information for columns..
            print_indices = ', '.join(map(str, col_indices[:self.max_display]))
            missing_string += f"   at columns: [{print_indices}"
            if (len(col_indices) > self.max_display): missing_string += ", ..."
            missing_string += "]\n"
        missing_string_len = max(map(len, missing_string.split("\n")))
        # Construct a header bar out of "=".
        horizontal_bar = "="*max(len(rows[0]), len(size_string),
                                 len(view_string)-1, missing_string_len)
        string = "\n" + horizontal_bar + "\n"
        string += view_string + size_string + f"\n\n"
        string += rows[0]
        string += rows[1]
        string += "-"*len(rows[0]) + "\n"
        for row in rows[2:]:                string += row
        if (len(self) > self.max_display): string += "  ...\n"
        string += "\n"
        string += missing_string
        string += horizontal_bar + "\n"
        return string

    # Define a convenience funciton for concatenating another
    # similarly typed and named data to self.
    def __iadd__(self, data):
        import time
        start = time.time()
        # Check to see if this is a data view object.
        if (self.view): raise(Data.Unsupported("This is a data alias and does not support in-place addition."))
        # Check for improper usage
        if type(data) != Data:
            raise(Data.Unsupported(f"In-place addition only supports type {Data}, but {type(data)} was given."))
        # Special case for being empty.
        if data.empty: return self
        # Special case for being empty.
        elif self.empty:
            self.names = data.names
            self.types = data.types
            # Load in the data
            for i,row in enumerate(data):
                # Update user on progress if too much time has elapsed..
                if (time.time() - start) > self.max_wait:
                    print(f" {100.*i/len(data):.2f}% in-place add", end="\r", flush=True)
                    start = time.time()
                self.append(row)
        # Add rows to this from the provided Data
        elif (set(self.names) == set(data.names)):
            # If the names are not in the same order, create a view
            # on the provided data with the correct order.
            if (tuple(self.names) != tuple(data.names)): data = data[self.names]
            # Load in the data
            for i,row in enumerate(data):
                # Update user on progress if too much time has elapsed..
                if (time.time() - start) > self.max_wait:
                    print(f" {100.*i/len(data):.2f}% in-place add", end="\r", flush=True)
                    start = time.time()
                self.append(row)
        # Add columns to this from the provided Data (if no columns conflict).
        elif (len(self) == len(data)) and (set(self.names).isdisjoint(data.names)):
            for col in data.names: self[col] = data[col]
        # Otherwise if a subset of columns are matching, add rows (and new columns).
        elif (set(self.names).issubset(data.names) or set(data.names).issubset(self.names)):
            # First add rows for all the same-named columns.
            other_names = set(data.names)
            shared_names = [n for n in self.names if n in other_names]
            for i,row in enumerate(data[:,shared_names]):
                # Update user on progress if too much time has elapsed..
                if (time.time() - start) > self.max_wait:
                    print(f" {100.*i/len(data):.2f}% in-place add (new rows)", end="\r", flush=True)
                    start = time.time()
                # Fill missing values with "None".
                if (len(shared_names) < len(self.names)):
                    # Construct a full row 
                    full_row = [None] * len(self.names)
                    i = 0
                    for j,n in enumerate(self.names):
                        if (n in other_names):
                            full_row[j] = row[i]
                            i += 1
                    row = full_row
                self.append(row)
            # Second add new columns for all the new names.
            my_names = set(self.names)
            new_names = [n for n in data.names if n not in my_names]
            for i,name in enumerate(new_names):
                # Update user on progress if too much time has elapsed..
                if (time.time() - start) > self.max_wait:
                    print(f" {100.*i/len(new_names):.2f}% in-place add (init cols)", end="\r", flush=True)
                    start = time.time()
                self[name] = None
            for r in range(len(data)):
                # Update user on progress if too much time has elapsed..
                if (time.time() - start) > self.max_wait:
                    print(f" {100.*i/len(data):.2f}% in-place add (fill cols)", end="\r", flush=True)
                    start = time.time()
                self[r-len(data),new_names] = data[r][new_names]
        # Return self
        return self

    # Define a convenience funciton for concatenating another
    # similarly typed and named data to self.
    def __add__(self, data):
        self = self.copy()
        self += data
        return self

    # Check whether or not the values match a row in data.
    def __contains__(self, row):
        # If the row is the wrong length, then certainly not.
        if (len(row) != self.shape[1]): return False
        # Otherwise, all rows of this Data have to be checked.
        for r in self:
            if all(v1 == v2 for (v1,v2) in zip(r,row)): return True
        return False

    # Given a row, generate the list of indices in this data that equal the row.
    def __eq__(self, row):
        for i in range(len(self)):
            if all(self[i] == row): yield i

    # Overwrite the "len" operator.
    def __len__(self):
        if (self.view): return len(self._row_indices)
        else:           return len(self.data)

    # Define the "append" operator using the insert operation. On a
    # list, the  "insert" operation takes about twice as long when
    # placing values at the end, but that speed is sacrificed to
    # remove the extra code.
    def append(self, index, value=None):
        if (value is None): index, value = len(self), index
        # Call the standard append operator, adding the element to self
        return  self.insert(index, value)

    # Redefine the "insert" method for this data.
    def insert(self, index, element):
        # Check to see if this is a data view object.
        if (self.view):
            raise(Data.Unsupported("This is a data alias and does not support assignment."))
        # Convert the element into a python list
        try:    element = list(element)
        except: raise(Data.BadValue(f"Invalid element, failed conversion to list."))
        # Check length in case names already exist
        if (self.names is not None):
            if (len(element) != self.shape[1]):
                raise(Data.BadElement(f"Only elements of length {self.shape[1]} can be added to this data."))
            # Try type casing the new element
            for i, (val, typ) in enumerate(zip(element, self.types)):
                # Ignore 'None' type values.
                if (val is None): pass
                elif (typ == type(None)):
                    # Update unassigned types with the new values' type
                    self.types[i] = type(val)
                elif (type(val) != typ):
                    # If not missing, then check the type
                    try:
                        # Try casting the element as the expected type
                        element[i] = typ(val)
                    except ValueError:
                        # Otherwise raise an error to the user
                        raise(Data.BadValue(f"Value '{val}' of type '{type(val)}' could not successfully be cast as '{typ}'."))
                    except TypeError:
                        print("Data error:", typ, typ==type(None))
        else:
            # Construct the expected "types" of this data
            self.types = [type(val) for val in element]
        if (self.names is None):
            # Construct default names for each column
            self.names = [str(i) for i in range(len(element))]
        # Call the standard insert operator, adding the element to self
        self.data.insert(index, Data.Row(self, element))

    # Make sure the copy of this data is a deep copy.
    def copy(self):
        import time
        start = time.time()
        # Special case for being empty.
        if (self.empty): raise(Data.Empty("Cannot copy empty data."))
        # Construct a new data set that is a copy of the data in this object.
        if self.view: rows, cols = self._row_indices, self._col_indices
        else:         rows, cols = map(list,map(range,self.shape))
        data = type(self)(names=list(self.names), types=list(self.types))
        for i,row in enumerate(rows):
            # Update user on progress if too much time has elapsed..
            if (time.time() - start) > self.max_wait:
                print(f" {100.*i/len(self):.2f}% copy", end="\r", flush=True)
                start = time.time()
            # Save time and skip data validation (since we already
            # know that the data was valid inside this object).
            row = Data.Row(data, [self.data[row][col] for col in cols])
            data.data.insert( len(data.data), row )
        # Return a new data object.
        return data

    # Overwrite the 'pop' method.
    def pop(self, index=-1):
        import time
        start = time.time()
        # Special case for being empty.
        if (self.empty): raise(Data.Empty("Cannot pop from empty data."))
        if self.view: raise(Data.Unsupported("Cannot 'pop' from a data view. Copy this object to remove items."))
        # Popping of a row
        if type(index) == int:
            return self.data.pop(index)
        # Popping of a column
        elif (type(index) == str):
            if index not in self.names:
                raise(Data.BadSpecifiedName(f"There is no column named {index} in this Data."))
            col = self.names.index(index)
            # Pop the column from "names", from "types" and then
            # return values from the "pop" operation.
            self.names.pop(col)
            self.types.pop(col)
            values = []
            for i,row in enumerate(self):
                # Update user on progress if too much time has elapsed..
                if (time.time() - start) > self.max_wait:
                    print(f" {100.*row/len(self):.2f}% pop", end="\r", flush=True)
                    start = time.time()
                values.append( row.pop(col) )
            return values
        else:
            raise(Data.BadIndex(f"Index {index} of type {type(index)} is not recognized."))

    # Overwrite the "sort" method to behave as expected.
    def sort(self):
        # If this is a view, sort the row indices.
        if self.view: self._row_indices.sort(key=lambda row_idx: self.data[row_idx][self._col_indices])
        else:         self.data.sort(key=lambda row: row.values)

    # ========================
    #      Custom Methods     
    # ========================

    # Custom function for mapping values to strings in the printout of self.
    def _val_to_str(self, v): 
        # Get the string version of the value.
        if not ((type(v) == Data) or (issubclass(type(v),Data))):
            if (type(v) == str): v = '"' + v + '"'
            string = str(v).replace("\n"," ")
        else:
            # Custom string for a 'data' type object.
            string = v.__str__(short=True)
        # Shorten the string if it needs to be done.
        if len(string) > self.max_str_len: 
            string = string[:self.max_str_len]+".."
        return string

    # Given an index (of any acceptable type), convert it into an
    # iterable of integer rows and a list of integer columns.
    # Input index is in terms of this data, output is in true data.
    def _index_to_rows_cols(self, index):
        # Special case for being empty.
        if (self.empty): raise(Data.Empty("Cannot get rows and cols from empty data."))
        # Standard usage.
        if (type(index) == int):
            rows = [self.row(index)]
            cols = [self.col(i) for i in range(self.shape[1])]
        # Case for column index access.
        elif (type(index) == str):
            if index not in self.names:
                raise(Data.UnknownName(f"This data does not have a column named '{index}'."))
            rows = [self.row(i) for i in range(len(self))]
            cols = [self.names.index(index)]
        # Case for slice-index access.
        elif (type(index) == slice):
            # Construct a new "data" with just the specified rows (deep copy)
            rows = [self.row(i) for i in range(len(self))[index]]
            cols = [self.col(i) for i in range(self.shape[1])]
        # Case for tuple-string index access where thera are two selected columns.
        elif ((type(index) == tuple) and (len(index) == 2) and
              (type(index[0]) == str) and (type(index[1]) == str)):
            rows = [self.row(i) for i in range(len(self))]
            cols = []
            for i in index:
                if i not in self.names:
                    raise(Data.UnknownName(f"This data does not have a column named '{i}'."))
                cols.append( self.names.index(i) )
        # Case where (row indices, col indices) were provided.
        elif ((type(index) == tuple) and (len(index) == 2)):
            if (type(index[0]) == int) and (type(index[1]) == int):
                # This index is accessing a (row, col) entry.
                rows = [self.row(index[0])]
                cols = [self.col(index[1])]
            elif ((type(index[0]) == int) and (type(index[1]) == str)):
                # This index is accessing a (row, col) entry with a named column.
                rows = [self.row(index[0])]
                cols = [self.names.index(index[1])]
            else:
                rows, cols = index

                # Handling the "rows"
                if (type(rows) == int):     rows = [self.row(rows)]
                elif (type(rows) == slice): rows = [self.row(i) for i in range(len(self))[rows]]
                elif is_iterable(rows):
                    rows = list(rows)
                    if   all(type(i)==int for i in rows):  rows = [self.row(i) for i in rows]
                    elif all(type(i)==bool for i in rows):
                        rows = [self.row(i) for (i,b) in enumerate(rows) if b]
                    else:
                        type_printout = sorted(map(str,set(map(type,rows))))
                        raise(Data.BadIndex(f"The provided row index, {index}, is not understood.\n It has types {type_printout}."))
                else:
                    type_printout = sorted(map(str,set(map(type,rows))))
                    raise(Data.BadIndex(f"The provided row index, {index}, is not understood.\n It is typed {type_printout}."))

                # Handling the "columns"
                if (type(cols) == int):     cols = [self.col(cols)]
                elif (type(cols) == slice): cols = [self.col(i) for i in range(self.shape[1])[cols]]
                elif is_iterable(cols):
                    col_ids = list(cols)
                    cols = []
                    for i,v in enumerate(col_ids):
                        if (type(v) not in {str,int,bool}):
                            raise(Data.BadIndex(f"The provided column index of type {type(v)}, {v}, is not understood."))
                        elif (type(v) == str):
                            if (v not in self.names):
                                raise(Data.UnknownName(f"This data does not have a column named '{v}'."))
                            i = self.names.index(v)
                        # If it is an int, use that as the index.
                        elif (type(v) == int): i = self.col(v)
                        # If it is a boolean and it is False, skip this index.
                        elif (type(v) == bool) and (not v): continue
                        elif (type(v) == bool) and v: i = self.col(i)
                        # Append the column index
                        cols.append( i )
                else:
                    type_printout = sorted(map(str,set(map(type,cols))))
                    raise(Data.BadIndex(f"The provided column index, {index}, is not understood.\n It has types {type_printout}."))
        # Iterable index access.
        elif is_iterable(index):
            index = list(index)
            # Case for iterable access of rows.
            if all(type(i)==int for i in index):
                rows = [self.row(i) for i in index]
                cols = [self.col(i) for i in range(self.shape[1])]
            # Case for iterable access of columns.
            elif all(type(i)==str for i in index):
                rows = [self.row(i) for i in range(len(self))]
                cols = []
                for i in index:
                    if i not in self.names:
                        raise(Data.UnknownName(f"This data does not have a column named '{i}'."))
                    cols.append( self.names.index(i) )
            # Case for boolean-index access to rows.
            elif all(type(i)==bool for i in index):
                rows = [self.row(i) for (i,b) in enumerate(index) if b]
                cols = [self.col(i) for i in range(self.shape[1])]
            # Undefined behavior for this index.
            else:
                type_printout = sorted(map(str,set(map(type,index))))
                raise(Data.BadIndex(f"The provided index, {index}, is not understood.\n It is typed {type_printout}."))
        # Undefined behavior for this index.
        else:
            try:    type_printout = sorted(map(str,set(map(type,index))))
            except: type_printout = str(type(index))
            raise(Data.BadIndex(f"\n  The provided index, {index}, is not understood.\n  It is typed {type_printout}."))
        # Return the final list of integer-valued rows and columns.
        return rows, cols

    # =======================================
    #      Saving and Loading from Files     
    # =======================================

    # Convenience method for loading from file.
    def load(path, *args, **read_data_kwargs):
        # Handle two different usages of the 'load' function.
        if (type(path) != str): 
            # If the user called "load" on an initialized data, ignore
            self = path
            if (len(args) == 1): path = args[0]
            else:                raise(Data.ImproperUsage("'load' method for Data must be given a path."))
        else:
            # Otherwise define 'self' as a new Data object.
            self = Data()
        # Check for extension, add default if none is provided.
        if "." not in path: path += ".pkl"
        # Check for compression
        compressed = path[-path[::-1].index("."):] in {"gz"}
        if compressed:
            import gzip
            file_opener = gzip.open
            base_path = path[:-path[::-1].index(".")-1]
            ext = base_path[-base_path[::-1].index("."):]
        else:
            file_opener = open
            ext = path[-path[::-1].index("."):]
        # Handle different base file extensions
        if (ext == "pkl"):
            import pickle
            with file_opener(path, "rb") as f:
                if self.empty: self =  pickle.load(f)
                else:          self += pickle.load(f)
        elif (ext == "dill"):
            try:    import dill
            except: raise(Data.MissingModule("Failed to import 'dill' module. Is it installed?"))
            with file_opener(path, "rb") as f:
                if self.empty: self =  dill.load(f)
                else:          self += dill.load(f)
        elif (ext in {"csv", "txt", "tsv"}):
            # Declare the read mode based on file type.
            mode = "r" + ("t" if compressed else "")
            # For big files, only read a random sample of the file by default.
            import os
            is_big = os.path.exists(path) and (os.path.getsize(path) > FILE_SAMPLE_SIZE)
            # If the "sample" is a float, assume its a ratio of lines.
            if ("sample" in read_data_kwargs) and (type(read_data_kwargs["sample"]) == float):
                read_data_kwargs["sample_ratio"] = read_data_kwargs.pop("sample")
            # By default, sample big data files.
            sample_unspecified = ("sample" not in read_data_kwargs)
            if (is_big and sample_unspecified):
                def read_chunks(f, num_bytes=2**20):
                    chunk = f.read(num_bytes)
                    while chunk:
                        yield chunk
                        chunk = f.read(num_bytes)
                # Open the file to read the number of lines.
                with file_opener(path, mode, errors='ignore') as f:
                    lines = sum(chunk.count("\n") for chunk in read_chunks(f))
                # Guess at a sample number by assuming lines are equal
                # sizes, try and grab approximately "FILE_SAMPLE_SIZE".
                sample_ratio = read_data_kwargs.pop("sample_ratio",
                    FILE_SAMPLE_SIZE/os.path.getsize(path) )
                sample_size = int(lines * sample_ratio)
                print("WARNING: Found",lines,"lines, randomly sampling",sample_size,"from this file.")
                print("         Use 'sample=None' if you want all lines from this file.")
                read_data_kwargs["sample"] = sample_size
            # Make the read operation verbose for large data files.
            if (is_big and ("verbose" not in read_data_kwargs)):
                read_data_kwargs["verbose"] = True
            # Set the separator based off the file extension if not provided.
            if ("sep" not in read_data_kwargs):
                if   (ext == "csv"): read_data_kwargs["sep"] = ","
                elif (ext == "txt"): read_data_kwargs["sep"] = " "
                elif (ext == "tsv"): read_data_kwargs["sep"] = "\t"
            # Open the file for an actual read.
            with file_opener(path, mode) as f:
                read_data_kwargs["opened_file"] = f
                if self.empty: self =  read_data(**read_data_kwargs)
                else:          self += read_data(**read_data_kwargs)
        else:
            raise(Data.Unsupported(f"Cannot load file with extension '{ext}'."))
        return self

    # Convenience method for saving to a file, offers automatic
    # creation of output folders (given they are not present).
    # WARNING: This method makes a temporary copy if `self.view`.
    def save(self, path, create=True):
        # Special case for being empty.
        if (self.empty): raise(Data.Empty("Cannot save empty data."))
        # Create the output folder if it does not exist.
        output_folder = os.path.split(os.path.abspath(path))[0]
        if create and not os.path.exists(output_folder): os.makedirs(output_folder)
        # Check for compression
        if "." not in path: path += ".pkl"
        compressed = path[-path[::-1].index("."):] == "gz"
        file_opener = open
        if compressed:
            import gzip
            file_opener = gzip.open
            base_path = path[:-path[::-1].index(".")-1]
            ext = base_path[-base_path[::-1].index("."):]
        else:
            ext = path[-path[::-1].index("."):]
        # Handle different base file extensions
        if (ext == "pkl"):
            import pickle
            with file_opener(path, "wb") as f:
                # Create a copy for the save operation if this is a view.
                if (self.view):
                    temp = self.copy()
                    pickle.dump(temp, f)
                    del temp
                else: pickle.dump(self, f)
        elif (ext == "dill"):
            try:    import dill
            except: raise(Data.MissingModule("Failed to import 'dill' module. Is it installed?"))
            with file_opener(path, "wb") as f:
                # Create a copy for the save operation if this is a view.
                if (self.view):
                    temp = self.copy()
                    dill.dump(temp, f)
                    del temp
                else: dill.dump(self, f)
        elif (ext in SEPARATORS):
            sep = SEPARATORS[ext]
            mode = "w" + ("t" if compressed else "")
            # Remove the seperator character from the 
            fix = lambda v: '"' + v.replace('"',"'") + '"' if sep in v else v
            with file_opener(path, mode) as f:
                print(sep.join(map(fix,self.names)), file=f)
                for row in self:
                    print_row = map(fix,(str(v) if (v is not None) else "" for v in row))
                    print(sep.join(print_row), file=f)
        else:
            raise(Data.Unsupported(f"Cannot save {'compressed ' if compressed else ''}file with base extension '{ext}'."))
        return self

    # ====================================
    #      Reorganizing Existing Data     
    # ====================================

    # Given a (sub)set of column names in this data, reorder the data
    # making those names first (with unprovided names remaining in
    # same order as before).
    def reorder(self, names):
        import time
        start = time.time()
        # Special case for being empty.
        if (self.empty):  raise(Data.Empty("Cannot reorder empty data."))
        elif (self.view): raise(Data.Unsupported("Cannot 'reorder' a data view. Copy this object to modify."))
        # Check for proper usage.
        my_names = set(self.names)
        for n in names:
            if (n not in my_names):
                raise(Data.BadSpecifiedName(f"No column named '{n}' exists in this data."))
        # Construct the full reordering of every row of data.
        order = [self.col(self.names.index(n)) for n in names]
        taken = set(order)
        order += [i for i in range(self.shape[1]) if i not in taken]
        # Re-order names, types, and all rows of data.
        self.names = [self.names[i] for i in order]
        self.types = [self.types[i] for i in order]
        for row in range(len(self)):
            # Update user on progress if too much time has elapsed..
            if (time.time() - start) > self.max_wait:
                print(f" {100.*row/len(self):.2f}% reorder", end="\r", flush=True)
                start = time.time()
            # Directly update the row (bypassing validation) because
            # we know all values were already validated.
            self[row].values = [self[row,i] for i in order]

    # Given a new list of types, re-cast all elements of columns with
    # changed types into the newly specified type.
    def retype(self, types, columns=None):
        import time
        start = time.time()
        # Special case for being empty and being a view.
        if (self.empty): raise(Data.Empty("Cannot retype empty data."))
        if (self.view): raise(Data.Unsupported("Cannot retype a data view, either retype original data or copy and then retype."))
        # Handle a single column or type being provided.
        if   (type(columns) == str): columns = [columns]
        elif (type(columns) == int): columns = [self.names[columns]]
        # Initialize "columns" if it was not provided to be the whole Data.
        if (columns is None):     columns = list(range(len(self.names)))
        if (type(types) == type): types = [types] * len(columns)
        elif (len(types) != len(columns)):
            raise(Data.BadSpecifiedType(f"{Data.retype} given {len(types)} types, epxected {len(columns)}."))
        # Verify that all columns are valid names, convert to integers.
        for i in range(len(columns)):
            if (type(columns[i]) == str):
                if (columns[i] not in self.names):
                    raise(Data.BadSpecifiedName(f"No column named '{col}' exists in this data."))
                columns[i] = self.names.index(columns[i])
            elif (type(columns[i]) == int):
                if not (-len(self.names) <= columns[i] < len(self.names)):
                    raise(Data.BadIndex(f"Provided column index {columns[i]} is out of range."))
            else: raise(Data.ImproperUsage(f"Unrecognized column index {columns[i]}."))
        for j,(new_t, c) in enumerate(zip(types, columns)):
            # Update user on progress if too much time has elapsed..
            if (time.time() - start) > self.max_wait:
                print(f" {100.*j/len(columns):.2f}% retype", end="\r", flush=True)
                start = time.time()
            old_t = self.types[c]
            if (new_t == old_t): continue
            # Update the stored type
            self.types[c] = new_t
            # Retype all non-missing elements in that column (in place)
            for i in range(len(self)):
                if (self[i,c] is None): continue
                try:
                    self[i,c] = new_t(self[i,c])
                except ValueError:
                    raise(Data.BadSpecifiedType(f"Type casting {new_t} for column {c} is not compatible with existing value '{self[i,c]}' on row {i}."))

    # Given a new column, add it to this Data.
    def add_column(self, column, name=None, idx=None):
        import time
        start = time.time()
        # Special case for being empty.
        if (self.empty):
            if (name is None): name = "0"
            self.names = []
            self.types = []
            idx = 0
        # Set the default index to add a column to be the end.
        if (idx == None): idx = self.shape[1]
        # Verify the name.
        if (name is None):
            num = 0
            while (str(num) in self.names): num += 1
            name = str(num)
        elif (type(name) != str):
            raise(Data.BadSpecifiedName(f"Only string names are allowed. Received name '{name}' with type {type(name)}."))
        # Set the name
        self.names.insert(idx, name)
        # Verify the column type dynamically. Add new values to all rows.
        new_type = type(None);
        i = -1
        for i,val in enumerate(column):
            # Update user on progress if too much time has elapsed..
            if (time.time() - start) > self.max_wait:
                print(f" {100.*i/len(self):.2f}% add column", end="\r", flush=True)
                start = time.time()
            # Verify valid index first..
            if (self.shape[1] > 1) and (i >= len(self)):
                # Remove the added name.
                self.names.pop(idx)
                # Remove the added elements if the length was not right
                for j in range(len(self)): self[j].pop(idx)
                # Raise error for too long of a column
                raise(Data.BadData(f"Provided column has at least {i+1} elements, more than the length of this data ({len(self)})."))
            # If this is the first column in the data.
            elif (self.shape[1] == 1):
                self.append(Data.Row(self, [val]))
            # Append the value to this row for normal operation.
            else: self[i].insert(idx, val)
            # Only add to missing values entry if it's not already there
            if (val is None):  pass
            # Capture the new type (type must be right)
            elif (new_type == type(None)): new_type = type(val)
            # Error out otherwise.
            elif (type(val) != new_type):
                # Remove the added name.
                self.names.pop(idx)
                # Remove the added elements because a problem was encountered.
                for j in range(i+1): self[j].pop(idx)
                # This is a new type, problem!
                raise(Data.BadValue(f"Provided column has multiple types. Original type {new_type}, but '{val}' has type {type(val)}."))
        # Verify the column length
        if (i < len(self)-1):
            # Remove the added name.
            self.names.pop(idx)
            # Remove the added elements if the length was not right
            for j in range(i+1): self[j].pop(idx)
            # Raise error for too short of a column
            raise(Data.BadData(f"Provided column has length {i+1}, less than the length of this data ({len(self)})."))
        # Finally, record the new type
        self.types.insert(idx, new_type)

    # Generate a pair of functions. The first function will map rows
    # of Data to a real-valued list. The second function will map
    # real-valued lists back to rows in the original space.
    def generate_mapping(self):
        if self.empty: raise(Data.ImproperUsage("Cannot map empty Data."))
        # Make sure we can handle this type of data
        if not all(t in {int,float,str} for t in self.types):
            raise(Data.Unsupported("A mapping is only designed for Data composed of <float>, <int>, and <str> typed values."))
        # Get those categoricals that need to be converted to reals
        names = list(self.names)
        types = list(self.types)
        cat_constants = {}
        cat_names = [n for (n,t) in zip(names,types) if (t == str)]
        cat_values = {n:sorted(set(self[n])-{None}) for n in cat_names}
        # Get the categorical simplex mappings.
        cat_mappings = {n:regular_simplex(len(cat_values[n]))
                        for n in cat_names}
        # Get the real values that have more than one unique value.
        real_values = {n:None for n in names if n not in cat_values}
        for n in real_values:
            unique = set()
            # Identify those columns (of reals) that have >1 unique value.
            for v in self[n]:
                unique.add(v)
                if len(unique) > 1: break
            else: real_values[n] = unique.pop()
        # Initialize stoarge for the indices
        num_inds = []
        cat_inds = []
        # Calculate the dimension of the real space (and the column names)
        real_names = []
        counter = 0
        for (n,t) in zip(names, types):
            if (t == str):
                real_names += [f"{n}-{i+1}" for i in range(len(cat_values[n])-1)]
                # Record the indices of categorical mappings
                cat_inds += list(counter+i for i in range(len(cat_values[n])-1))
                if (len(cat_inds) > 0): counter = cat_inds[-1] + 1
            elif (real_values[n] == None):
                real_names.append( n )
                # Record the indices of numerical values
                num_inds.append( counter )
                counter += 1

        # Generate a function that takes a row in the original space
        # and generates a row in the associated real-valued space.
        def to_real(row, fill=False):
            # Check for row length
            if (len(row) != len(names)):
                raise(Data.BadElement(f"Provided row has {len(row)} elements, expected {len(names)}."))
            # Bulid the real-valued vector
            real_row = []
            for (n,t,v) in zip(names, types, row):
                # Check for the type of the elements of the row
                if (v is None):
                    if (t == str):
                        real_row += [None] * len(cat_mappings[n][0])
                    elif (real_values[n] == None):
                        real_row += [None]
                    continue
                elif (type(v) != t) and (t != type(None)):
                    try:    v = t(v)
                    except: raise(Data.BadValue(f"Value '{v}' in provided row has wrong type. Got {type(v)}, expected {t} and could not succesfully cast."))
                # Handle the addition of a proper value
                if (t == str):
                    # WARNING: Not handling "unrecognized categories"
                    if v in cat_values[n]:
                        cat_index = cat_values[n].index(v)
                        mapped_vec = cat_mappings[n][cat_index]
                        real_row += list(mapped_vec)
                    elif (not fill):
                        # Only raise an error if it's wanted
                        raise(Data.BadValue(f"Unrecognized categorical value {v} for column {n}."))
                    else:
                        # Put a filler value in for the unknown (middle category)
                        real_row += [0.] * (len(cat_values[n]) - 1)
                elif (real_values[n] == None):
                    real_row += [float(v)]
            # Check for row length
            if (len(real_row) != len(real_names)):
                raise(Data.BadElement(f"Provided row has {len(row)} elements, translation to {len(real_names)} unsuccesful, only created {len(real_row)}."))
            # Return the real-valued vector
            return real_row

        # Generate a function that takes a row in the real-valued
        # space and generates a row in the original space.
        def real_to(real_row, bias={}):
            import numpy as np
            # Verify length of real-vector
            real_row = list(real_row)
            if (len(real_row) != len(real_names)):
                raise(Data.BadElement(f"Provided real vector has {len(real_row)} elements, expected {len(real_names)}."))
            # Build the original row
            row = []
            for (n,t) in zip(names, types):
                if (t == str):
                    num_categories = len(cat_values[n])
                    vec = np.array(real_row[:num_categories-1])
                    # Get the weights for each of the categorical values.
                    cat_weights = np.array(
                        [(bias[n][c] if (n in bias and c in bias[n]) else 1.0)
                         for c in cat_values[n]])
                    # Handle reverse-categorical mapping
                    closest_cat = np.argmin(np.sum((cat_mappings[n] - vec)**2, axis=1) / cat_weights)
                    category = cat_values[n][closest_cat]
                    row += [category]
                    # Reduce the length of the real-valued row
                    real_row = real_row[num_categories-1:]
                elif (real_values[n] == None):
                    if (t == int):
                        # Use the rounded version of the integer
                        row += [int(real_row.pop(0) + .5)]
                    else:
                        # Use the float representation of the numpy floatf
                        row += [float(real_row.pop(0))]
                else:
                    # Fill with the only value that was provided.
                    row += [real_values[n]]
            if (len(real_row) > 0):
                raise("Left over values!")
            # Check for row length
            if (len(row) != len(names)):
                raise(Data.BadElement(f"Provided row has {len(real_row)} elements, translation to {len(names)} unsuccesful, only created {len(row)}."))
            return row
        # Return the two mapping functions and some info
        return to_real, real_to, real_names, num_inds, cat_inds

    # Convert this Data automatically to a real-valued array.
    # Return real-valued array, function for going to real from
    # elements of this Data, function for going back to elements of
    # this data from a real vector.
    def to_matrix(self, print_column_width=70):
        import time
        start = time.time()
        import numpy as np
        to_real, real_to, real_names, num_inds, cat_inds = self.generate_mapping()
        data = []
        for i,row in enumerate(self):
            # Update user on progress if too much time has elapsed..
            if (time.time() - start) > self.max_wait:
                print(f" {100.*i/len(self):.2f}% to matrix", end="\r", flush=True)
                start = time.time()
            # How to handle rows with missing values? Add column for "is missing"?
            if (None in row): continue
            data.append( to_real(row) )
        if (len(data) == 0):
            raise(Data.BadData("No rows in this data are complete, resulting matrix empty."))
        array = np.array(data)
        # Container for important post-processing information. 
        # 
        # Numeric.to_real -- the function for processing regular
        #                    vectors into associated real vectors
        # Numeric.real_to -- the function for processing real vectors
        #                    back into regular vector
        # Numeric.names   -- meaningful column names for the real vectors
        # Numeric.nums    -- standard numerical indices
        # Numeric.cats    -- translated categorical indices
        # Numeric.data    -- The numeric version of the data.
        # Numeric.shift   -- How to shift this data to have min 0.
        # Numeric.scale   -- How to scale this data (after shift) to 
        #                    have a domain of [0., 1.]
        class Numeric:
            def __str__(self):
                opener = "  ["
                str_real_names = [opener]
                for n in real_names:
                    if not ((len(str_real_names[0]) == len(opener)) or
                            (len(str_real_names[-1]) + len(n) < print_column_width)):
                        str_real_names.append("   ")
                    str_real_names[-1] += f"'{n}', "
                str_real_names[-1] = str_real_names[-1][:-2] + "]"
                str_real_names = "\n".join(str_real_names)
                return f"Numeric object for data with {len(real_names)} columns named:\n{str_real_names}"
        # Generate a container object and fill it.
        numeric = Numeric()
        numeric.to_real = to_real
        numeric.real_to = real_to
        numeric.names = real_names
        numeric.nums = num_inds
        numeric.cats = cat_inds
        numeric.data = array
        # Compute the shift and scale for normalization (of numeric values)
        numeric.shift = np.min(array, axis=0)
        numeric.scale = np.max(array, axis=0) - numeric.shift
        numeric.shift[cat_inds] = 0.
        numeric.scale[cat_inds] = 1.
        # Return the container object
        return numeric

    # Generate a compact numpy structured array from the contents of self.
    def to_struct(self):
        import time
        start = time.time()
        import numpy as np
        # Generate the dtypes
        dtypes = []
        for i,(n,t) in enumerate(zip(self.names,self.types)):
            # Update user on progress if too much time has elapsed..
            if (time.time() - start) > self.max_wait:
                print(f" {100.*i/len(self):.2f}% to struct", end="\r", flush=True)
                start = time.time()
            if (t != str):
                pair = (n,) + NP_TYPES[t]
            else:
                max_len = max(len(s) for s in self[n] if type(s) == str)
                pair = (n,) + NP_TYPES[t][:1]+(max_len,)
            dtypes.append(pair)
        dtypes = np.dtype(dtypes)
        # Return the numpy structured array
        return np.array([tuple(row) for row in self if (None not in row)], 
                        dtype=dtypes)

    # Collect the dictionaries of unique values (with counts) for each column.
    def counts(self, columns=None):
        import time
        start = time.time()
        if (columns is None): columns = self.names
        column_info = {n:{} for n in self.names}
        for i,row in enumerate(self):
            # Update user on progress if too much time has elapsed..
            if (time.time() - start) > self.max_wait:
                print(f" {100.*i/len(self):.2f}% counts", end="\r", flush=True)
                start = time.time()
            for n,val in zip(columns, row):
                # If this column has been removed (because it is
                # unhashable), then skip it in the processing
                if n not in column_info: pass
                # Try to add the new value
                try:
                    column_info[n][val] = column_info[n].get(val,0) + 1
                except TypeError:
                    # Cannot hash an element of self[n], disable tracking
                    column_info.pop(n)
        return column_info

    # Generate a "view" on this data object that only has the first
    # occurrence of its unique rows and return it.
    def unique(self):
        import time
        from util.system import hash
        rows = []
        found = set()
        start = time.time()
        for i,row in enumerate(self):
            # Update user on progress if too much time has elapsed..
            if (time.time() - start) > self.max_wait:
                print(f" {100.*i/len(self):.2f}% unique", end="\r", flush=True)
                start = time.time()
            # Get the hashed value by consecutively hashing all of the
            # values within this row. Hashing the entire row sometimes
            # produces changing hashes (likely based on memory locations).
            hashed = hash(list(row))
            if hashed not in found:
                found.add(hashed)
                rows.append(i)
        return self[rows]

    # Given a list of column names, modify this Data so that all
    # specified column names are stacked in lists associated with
    # unique combinations of unspecified column names.
    def stack(self, columns):
        if (self.view): raise(Data.Unsupported("Cannot 'stack' a data view, either 'stack' original data or copy and then 'stack'."))
        import time
        from util.system import hash
        start = time.time()
        # Adjust for usage (where user provides only one column).
        if (type(columns) != list): columns = [columns]
        # Verify all of the provided columns.
        for i in range(len(columns)):
            if   (type(columns[i]) == int): columns[i] = self.names[i]
            elif (type(columns[i]) == str):
                if (columns[i] not in self.names):
                    raise(Data.BadIndex("There is no column named '{columns[i]}' in this data."))
            else:
                raise(Data.BadIndex("The index '{columns[i]}' is not recognized. Only {int} and {str} are allowed."))
        # Create a view of the columns that will be kept for hashing.
        keep_columns = [i for (i,n) in enumerate(self.names) if n not in columns]
        keep_view = self[:,keep_columns]
        # Get all columns that will be stacked and rename them.
        stacked_columns = [n for n in self.names if n in columns]
        for i in map(self.names.index, stacked_columns):
            self.names[i] += " unstacked"
        old_col_names = [n + " unstacked" for n in stacked_columns]
        # Get the indices of the old and new columns.
        old_col_idxs = [self.names.index(n) for n in old_col_names]
        # Track the first occurrence of each 
        lookup = {}
        to_pop = []
        for i in range(len(self)):
            # Update user on progress if too much time has elapsed..
            if (time.time() - start) > self.max_wait:
                print(f" {100.*i/len(self):.2f}% stack", end="\r", flush=True)
                start = time.time()
            # Hash the non-stacked columns of this row.
            hashed = hash(list(keep_view[i]))
            # hashed = hash(list(self[i]))
            if hashed in lookup:
                row, stack = lookup[hashed]
                to_pop.append(i)
            else:
                row, stack = len(lookup), {c:list() for c in stacked_columns}
                lookup[hashed] = (row, stack)
            # Copy the values from the row into the stacks.
            for (new_c, old_c) in zip(stacked_columns, old_col_idxs):
                stack[new_c].append( self[i].values[old_c] )
        # Pop out all of the now-useless rows.
        for i in to_pop[::-1]:
            # Update user on progress if too much time has elapsed..
            if (time.time() - start) > self.max_wait:
                print(f" {100.*i/len(self):.2f}% stack - pop rows", end="\r", flush=True)
                start = time.time()
            self.pop(i)
        # Pop out all of the old columns.
        for c in old_col_names: self.pop(c)
        # Insert all of the stacked values into new columns.
        new_stacks = sorted(lookup.values(), key=lambda i: i[0])
        for i,c in enumerate(stacked_columns):
            # Update user on progress if too much time has elapsed..
            if (time.time() - start) > self.max_wait:
                print(f" {100.*i/len(stacked_columns):.2f}% stack - add stacks", end="\r", flush=True)
                start = time.time()
            self[c] = (stack[c] for (_,stack) in new_stacks)


    # Undo the "stack" operation. Given columns that contain
    # iterables, unstack them by duplicating all unspecified columns
    # and creating new entries in the data.
    def unstack(self, columns):
        if (self.view): raise(Data.Unsupported("Cannot 'unstack' a data view, either 'unstack' original data or copy and then 'unstack'."))
        import time
        from util.system import hash
        start = time.time()
        # Adjust for usage (where user provides only one column).
        if (type(columns) != list): columns = [columns]
        # Verify all of the provided columns.
        for i in range(len(columns)):
            if   (type(columns[i]) == int): columns[i] = self.names[i]
            elif (type(columns[i]) == str):
                if (columns[i] not in self.names):
                    raise(Data.BadIndex("There is no column named '{columns[i]}' in this data."))
            else:
                raise(Data.BadIndex("The index '{columns[i]}' is not recognized. Only {int} and {str} are allowed."))
        # Get all columns that will be stacked and rename them.
        unstacked_columns = [n for n in self.names if n in columns]
        for i in map(self.names.index, unstacked_columns):
            self.names[i] += " stacked"
        old_col_names = [n + " stacked" for n in unstacked_columns]
        # Initialize all stacked columns to hold lists of values.
        for n in unstacked_columns: self[n] = (None for i in range(len(self)))
        # Get the indices of the old and new columns.
        new_col_idxs = [self.names.index(n) for n in unstacked_columns]
        # Unstack all 
        i = 0
        while (i < len(self)):
            # Update user on progress if too much time has elapsed..
            if (time.time() - start) > self.max_wait:
                print(f" {100.*i/len(self):.2f}% unstack", end="\r", flush=True)
                start = time.time()
            not_none = lambda v: (v is not None)
            # Retreive the column values in a dictionary.
            try:    values = {c:list(self[i,c]) for c in old_col_names if not_none(self[i,c])}
            except: raise(Data.BadData("Could not convert stack into list. {self[i]}"))
            # Check to make sure the lengths are all the same.
            stack_size = set(map(len,values.values()))
            if (len(stack_size) > 1):
                raise(Data.BadData("Row contains stacks of different length. {self[i]}"))
            # If there are no stacked values, remove this row and continue.
            elif (len(stack_size) == 0):
                i += 1
                continue
            stack_size = stack_size.pop()
            # Loop over the stack size
            for step in range(stack_size-1):
                # Populate a new row.
                new_row = list(self[i])
                for (new_c, old_c) in zip(new_col_idxs, old_col_names):
                    new_row[new_c] = values[old_c].pop(-1)
                # Insert the new row.
                self.insert(i+1, new_row)
            # Increment if the stack size is zero.
            if (stack_size == 0): i += 1
            # Otherwise perform the last unstack operation.
            else:
                for (new_c, old_c) in zip(new_col_idxs, old_col_names):
                    self[i,new_c] = values[old_c].pop(-1)
                i += stack_size
        # Pop out all of the old columns.
        for c in old_col_names: self.pop(c)

    # Given a Data that has at least one column with the same names as
    # a column in self, collect all those values in non-mutual names
    # in lists of values where the shared columns had the same content.
    # 
    # Example:
    #   Combined with "unique", this function can be used to convert a
    #   struct where some rows are repeats of each other having unique
    #   values in only one column to a Data object with only unique
    #   rows and one column contains lists of values associated with
    #   each unique row.
    # 
    #     data.unique([group-by columns]).copy().collect(data)
    # 
    #   The above is equivalent to the in-place version:
    # 
    #     data.stack([columns to stack])
    # 
    #   However, the collect method can be passed any data object,
    #   which may make it more flexible for dynamic data collection.
    def collect(self, data):
        import time
        from util.system import hash
        # Get the names of shared columns and indices in each.
        match_names = set(n for n in self.names if n in data.names)
        self_columns = [i for (i,n) in enumerate(self.names) if n in match_names]
        # Sort the columns of self to be in the same order as that of other.
        self_columns = sorted(self_columns, key=lambda i: data.names.index(self.names[i]))
        other_columns = [i for (i,n) in enumerate(data.names) if n in match_names]
        # Check for duplicate column names.
        if (len(self_columns) != len(other_columns)):
            raise(Data.BadData("The provided Data to collect has duplicate column names."))
        # Collection columns
        names_to_collect = [n for n in data.names if n not in match_names]
        indices_to_collect  = [i for (i,n) in enumerate(data.names) if n not in match_names]
        collections = {n:[] for n in names_to_collect}
        # Add columns for holding the matches
        for n in names_to_collect:
            self.add_column(([] for i in range(len(self))), name=n)
        # Generate a set of lookups (hashed values even for mutable types)
        index_of_row = {}
        for i,row in enumerate(self):
            hash_value = hash([row[c] for c in self_columns])
            index_of_row[hash_value] = i
        # Paired list of source -> destination indices for copying.
        source_dest = list(zip(indices_to_collect, names_to_collect))
        start = time.time()
        # Perform the serach process
        for i,row in enumerate(data):
            # Update user on progress if too much time has elapsed..
            if (time.time() - start) > self.max_wait:
                print(f" {100.*i/len(data):.2f}% collect", end="\r", flush=True)
                start = time.time()
            # Convert row into its hash value, lookup storage location.
            hash_value = hash([row[c] for c in other_columns])
            if hash_value in index_of_row:
                row_idx = index_of_row[hash_value]
                for source, dest in source_dest:
                    self[row_idx, dest].append(row[source])
            else:
                print("Could not find:", [row[c] for c in other_columns])
        # Return the self (that has been modified)
        return self

    # Return an iterator that provides "k" (rest, fold) sub-data
    # from this data. Randomly shuffle indices with seed "seed".
    def k_fold(self, k=10, seed=0, only_indices=False):
        # Generate random indices
        import random
        old_state = random.getstate()
        random.seed(seed)
        indices = list(range(len(self)))
        random.shuffle(indices)
        # Reset the random number generator as not to muck with
        # other processes that might be using it.
        random.setstate(old_state)
        # Store some variables for generating the folds
        total = len(self)
        if (type(self) != Data): only_indices = True
        if not only_indices:     source = self
        for batch in range(k):
            # Find the indices for training and testing
            first = int(.5 + batch * total / k)
            last = int(.5 + (batch + 1) * total / k)
            fold = indices[first : last]
            rest = indices[:first] + indices[last:]
            if only_indices: yield rest, fold
            else:            yield source[rest], source[fold]

    # Use a prediction model to fill missing values in a provided row.
    def fill(self, row, model=None, weights=None, bias={}):
        import numpy as np
        numeric = self.to_matrix()
        # Pick the filling model based on data size.
        if (model is None):
            # Use Voronoi if there are fewer than 10000 points.
            if (len(self) <= 5000):
                from util.approximate import Voronoi, unique
                model = unique(Voronoi)()
            # Otherwise use nearest neighbor (can't get points + weights from NN)
            else:
                from util.approximate import unique, condition
                samples = min(numeric.data.shape[0], 10000)
                dim = min(numeric.data.shape[1], 1000)
                # Use nearest neighbor (can't get points + weights from NN)
                from util.approximate import NearestNeighbor
                model = condition(unique(NearestNeighbor), dim=dim, samples=samples)()
        # Set the weights accordingly
        if (weights is None):
            weights = np.ones(numeric.data.shape[1])
        elif (len(weights) != self.shape[1]):
            raise(Data.BadValue("Weights vector is length {len(weights)}, expected length {self.shape[1]}."))
        else:
            # Convert the provided weight to the correct shape.
            col_weights, weights = weights, []
            col_inds = list(range(len(numeric.names)))
            while (len(col_inds) > 0):
                if (col_inds[0] not in numeric.cats):
                    col_inds.pop(0)
                    weights.append( col_weights.pop(0) )
                else:
                    for i in range(1,len(col_inds)):
                        not_categorical = (col_inds[i] not in numeric.cats)
                        beginning_of_next = ("1" == 
                            numeric.names[col_inds[i]].split('-')[-1])
                        if (not_categorical or beginning_of_next): break
                    else: i += 1
                    col_inds = col_inds[i:]
                    weights += [col_weights.pop(0)] * i
            weights = np.array(weights)
        # Get the indices of the known and unknown values in this row.
        row_known = [i for i in range(len(row)) if (row[i] is not None)]
        row_unknown = [i for i in range(len(row)) if (row[i] is None)]
        if len(row_unknown) == 0: raise(Data.BadValue("Provided row had no missing values."))
        # Get the numeric version of the provided row.
        numeric_row = numeric.to_real(row, fill=True)
        # Identify the indices of known values and unknown values.
        known_values = np.array([i for i in range(len(numeric_row))
                                 if (numeric_row[i] is not None)])
        unknown_values = np.array([i for i in range(len(numeric_row))
                                   if (numeric_row[i] is None)])
        # Get the part of the numeric row
        no_none_numeric_row = np.array([numeric_row[i] for i in known_values])
        # Normalize the numeric row (to debias numeric scale differences)
        no_none_numeric_row = ((no_none_numeric_row - numeric.shift[known_values])
                               / numeric.scale[known_values]) * weights[known_values]
        # Get the normalized training point locations.
        normalized_numeric_data = ((numeric.data - numeric.shift)
                                   / numeric.scale) * weights
        # Fit the model and make a prediction for this row.
        if hasattr(model, "WeightedApproximator"):
            # Fit the model (just to the points)
            model.fit(normalized_numeric_data[:,known_values])
            del(normalized_numeric_data)
            # Get the source points and source weights for the prediction
            pts, wts = model.predict(np.array(no_none_numeric_row))
            # Compute the fill row by performing the weighted sum.
            fill_row = np.sum((numeric.data[pts,:][:,unknown_values].T * wts), axis=1)
            # Convert points and weights into python list (in case they're not)
            pts = list(pts)
            wts = list(wts)
        else:
            # The model makes predictions using all points.
            # Fit the model to the input points and output points.
            model.fit(normalized_numeric_data[:,known_values], 
                      normalized_numeric_data[:,unknown_values])
            del(normalized_numeric_data)
            pts = list(range(numeric.data.shape[0]))
            wts = [1 / len(pts)] * len(pts)
            # Use the model to make a prediction.
            fill_row = model.predict(no_none_numeric_row)
            # De-normalize the predicted output.
            fill_row = ((fill_row / weights[unknown_values]) * 
                        numeric.scale[unknown_values] - 
                        numeric.shift[unknown_values])
        # Pad fill row with 0's so that it is the correct length for conversion.
        fill_row = [0.] * len(known_values) + list(fill_row)
        # python3 -m pytest data.py
        # Transfer the filled numeric row into the original row
        fill_row = numeric.real_to(fill_row, bias=bias)
        for i,val in enumerate(fill_row):
            if (row[i] is None):
                # Set the value in the row to be the predicted fill value.
                row[i] = val
            else:
                # Backwards correct predicted output to have known values.
                fill_row[i] = row[i]
        prediction_model = str(model)
        # Construct a "Prediction" object with info about the prediction.
        class Prediction:
            parent = self
            model = prediction_model
            given = row_known
            filled = row_unknown
            predictors = pts
            weights = wts
            data = fill_row
            def __str__(self): 
                string =  f"Prediction made with {self.model}\n"
                string += f"  Given {[self.parent.names[i] for i in self.given]}\n"
                string += f"   {[self.data[i] for i in self.given]}\n"
                string += f"  Filled {[self.parent.names[i] for i in self.filled]}\n"
                string += f"   {[self.data[i] for i in self.filled]}\n"
                string += f"  Indices of source row (collections)\n"
                string += f"   {self.predictors}\n"
                string += f"  Weights of source row (collections)\n"
                string += f"   {self.weights}\n"
                return string
        return Prediction()

    # Given a set of columns of this data to try and predict, run a
    # k-fold cross validation over predictions using 'fill'.
    def predict(self, target_columns, model=None, weights=None, bias={}, k=10):
        import numpy as np
        # Get the numeric representation of self.
        numeric = self.to_matrix()
        # Pick the filling model based on data size.
        if (model is None):
            from util.approximate import unique, condition
            samples = min(numeric.data.shape[0], 10000)
            dim = min(numeric.data.shape[1], 1000)
            # Use nearest neighbor (can't get points + weights from NN)
            from util.approximate import NearestNeighbor
            model = condition(unique(NearestNeighbor), dim=dim, samples=samples)()
        # Set the weights accordingly
        if (weights is None):
            weights = np.ones(numeric.data.shape[1])
        elif (len(weights) != self.shape[1]):
            raise(Data.BadValue("Weights vector is length {len(weights)}, expected length {self.shape[1]}."))
        else:
            # Convert the provided weight to the correct shape.
            col_weights, weights = weights, []
            col_inds = list(range(len(numeric.names)))
            while (len(col_inds) > 0):
                if (col_inds[0] not in numeric.cats):
                    col_inds.pop(0)
                    weights.append( col_weights.pop(0) )
                else:
                    for i in range(1,len(col_inds)):
                        not_categorical = (col_inds[i] not in numeric.cats)
                        beginning_of_next = ("1" == 
                            numeric.names[col_inds[i]].split('-')[-1])
                        if (not_categorical or beginning_of_next): break
                    else: i += 1
                    col_inds = col_inds[i:]
                    weights += [col_weights.pop(0)] * i
            weights = np.array(weights)
        # Make sure the targets are in a list
        if type(target_columns) == str: 
            target_columns = [target_columns]
        elif type(target_columns) != list: 
            raise(Data.BadTarget("Target must either be a string (column name) or list of strings (column names)."))
        # Get the data all normalized (and weighted)
        normalized_data = weights * (numeric.data - numeric.shift) / numeric.scale
        print("normalized_data.shape: ",normalized_data.shape)
        # Identify those columns that are being predicted
        target_column_indices = [self.names.index(c) for c in target_columns]
        results = Data(names=[c + " Predicted" for c in target_columns]+["Prediction Index"],
                       types=[self.types[i] for i in target_column_indices]+[int])
        # Identify the numeric ranges of those columns
        indices = set(target_column_indices)
        sample = numeric.to_real([
            (v if i in indices else None)
            for i,v in enumerate(self[0])])
        del(indices)
        train_cols = np.array([i for (i,v) in enumerate(sample) if (v is None)])
        test_cols =  np.array([i for (i,v) in enumerate(sample) if (v is not None)])
        del(sample)
        # Cycle through and make predictions.
        for i,(train_rows, test_rows) in enumerate(
                Data.k_fold(range(numeric.data.shape[0]), k=k)):
            print(f"  Fold {i+1} of {k}.. ", end="", flush=True)
            train_data = normalized_data[train_rows]
            print(f"fitting {i+1} of {k}.. ", end="", flush=True)
            model.fit( normalized_data[train_rows,:][:,train_cols], 
                       normalized_data[train_rows,:][:,test_cols]   )
            print(f"predicting {i+1} of {k}.. ", end="", flush=True)
            predictions = model.predict( normalized_data[test_rows,:][:,train_cols] )
            # De-normalize predictions
            predictions = ( (predictions / weights[test_cols]) * 
                            numeric.scale[test_cols] + 
                            numeric.shift[test_cols] )
            print(f"storing.. {i+1} of {k}", end="\r", flush=True)
            # Store the prediction results.
            for j,i in enumerate(test_rows):
                row = list(numeric.data[i,train_cols]) + list(predictions[j,:])
                row = numeric.real_to(row, bias=bias)
                results.append( [row[i] for i in target_column_indices] + [i] )
            print(" "*70,end="\r",flush=True)
        # Sort results by the original index
        results.sort(key=lambda r: r[-1])
        results.pop("Prediction Index")
        # Return the results in a new Data object.
        return results

    # Compute the pairwise effects between columns. Use the following:
    # 
    #    number vs. number     -- Correlation coefficient between the two sequences.
    #    category vs. number   -- "method" 1-norm difference between full distribution
    #                             and conditional distributions for categories.
    #    category vs. category -- "method" total difference between full distribution
    #                             of other sequence given value of one sequence.
    # 
    # Print out the sorted table of pairwise effects between columns,
    # showing the highest effects first, the smallest last.
    def effect(self, compare_with=None, method="mean", display=True, **kwargs):
        from itertools import combinations
        from util.stats import effect
        if (compare_with is None):         compare_with = set(self.names)
        elif (type(compare_with) == list): compare_with = set(compare_with)
        else:                              compare_with = {compare_with}
        # Print out the effect in column form (not matrix form).
        effs = []
        for (col_1, col_2) in combinations(self.names, 2):
            if (col_1 in compare_with):
                eff = effect(list(self[col_1]), list(self[col_2]), method=method, **kwargs)
                effs.append( (col_1, col_2, eff) )
            elif (col_2 in compare_with):
                eff = effect(list(self[col_1]), list(self[col_2]), method=method, **kwargs)
                effs.append( (col_2, col_1, eff) )
        # Convert an effect to a sortable number (lowest most important).
        def to_num(eff): 
            if type(eff) == dict: return -sum(eff.values()) / len(eff)
            else:                 return -abs(eff)
        # Convert an effect to a printable string.
        def to_str(eff):
            if type(eff) == dict:
                eff_str = []
                for key in sorted(eff, key=lambda k: -abs(eff[k])):
                    eff_str += [f"'{key}':{eff[key]:5.2f}"]
                return f"{-to_num(eff):5.2f}  {{"+", ".join(eff_str)+"}"
            else:
                return f"{eff:5.2f}"
        # Sort the data by magnitude of effect. (most effected -> first)
        effs = sorted(effs, key=lambda row: to_num(row[-1]))
        # Do a quick return without printing if display is turned off.
        if (not display): return effs
        # Print out the effects between each column nicely.
        max_len_1 = max( max(map(lambda i:len(i[0]), effs)), len("Column 1") )
        max_len_2 = max( max(map(lambda i:len(i[1]), effs)), len("Column 2") )
        header = f"{'Column 1':{max_len_1}s}  |  {'Column 2':{max_len_2}s}  |  Effect"
        rows = []
        for (col_1, col_2, eff) in effs:
            eff = to_str(eff)
            rows += [f"{col_1:{max_len_1}s}  |  {col_2:{max_len_2}s}  |  {eff}"]
        row_len = max(len(header), max(map(len, rows)))
        rows = ["", '-'*row_len, header, '-'*row_len] + rows + ['-'*row_len, ""]
        for row in rows: print(row)
        # Return the sorted effect triple list [(col 1, col 2, effect)].
        return effs

    # Give an overview (more detailed than just "str") of the contents
    # of this data. Useful for quickly understanding how data looks.
    def summarize(self, max_display=None, file=sys.stdout):
        # Define a new print function that redirects to the provided file.
        def print_to_file(*args, **kwargs):
            kwargs['flush'] = True
            kwargs['file'] = file
            return print(*args, **kwargs)
        # Special case for an empty data
        if len(self) == 0:
            print_to_file(self)
            return
        # Set the "max_display" to the default value for this class
        if (max_display is None): max_display = self.max_display
        num_rows, num_cols = self.shape
        print_to_file(f"SUMMARY:")
        print_to_file()
        print_to_file(f"  This data has {num_rows} row{'s' if num_rows != 1 else ''}, {num_cols} column{'s' if num_cols != 1 else ''}.")
        num_numeric = sum(1 for t in self.types if t in {float,int})
        print_to_file(f"    {num_numeric} column{'s are' if num_numeric != 1 else ' is'} recognized as numeric, {num_cols-num_numeric} {'are' if (num_cols-num_numeric) != 1 else 'is'} categorical.")
        # Get some statistics on the missing values.
        is_none = lambda v: (v is None)
        missing_rows = {r:sum(map(is_none,v)) for (r,v) in enumerate(self) if (None in v)}
        if len(missing_rows) > 0:
            missing_cols = {c:sum(map(is_none,self[n])) for (c,n) in enumerate(self.names) if (None in self[n])}
            row_indices = sorted(missing_rows)
            col_indices = [self.names[i] for i in sorted(missing_cols)]
            total_missing_values = sum(missing_rows.values())
            total_values = num_rows * num_cols
            print_to_file(f"    {len(missing_rows)} row{'s have' if len(missing_rows) != 1 else ' has'} missing values.")
            print_to_file(f"    {len(missing_cols)} column{'s have' if len(missing_cols) != 1 else ' has'} missing values.")
            print_to_file(f"    in total, {total_missing_values} of all {total_values} are missing.")
        print_to_file()
        print_to_file("COLUMNS:")
        print_to_file()
        name_len = max(map(len, self.names))
        type_len = max(map(lambda t: len(str(t)), self.types))
        # Describe each column of the data
        for c,(n,t) in enumerate(zip(self.names, self.types)):
            # Count the number of elements for each value
            counts = {}
            to_string = False
            for val in self[n]:
                if to_string: val = str(val)
                try: counts[val] = counts.get(val,0) + 1
                except TypeError:
                    to_string = True
                    val = str(val)
                    counts[val] = counts.get(val,0) + 1
            print_to_file(f"  {c:{len(str(self.shape[1]))}d} -- \"{n}\"{'':{1+name_len-len(n)}s}{str(t):{type_len}s} ({len(counts)} unique value{'s' if (len(counts) != 1) else ''})")
            # Remove the "None" count from "counts" to prevent sorting problems
            none_count = counts.pop(None, 0)
            # For the special case of ordered values, reduce to ranges
            if (t in {int,float}) and (len(counts) > max_display):
                if (none_count > 0):
                    perc = 100. * (none_count / len(self))
                    print_to_file(f"    None                   {none_count:{len(str(len(self)))}d} ({perc:5.1f}%) {'#'*round(perc/2)}")
                # Order the values by intervals and print
                min_val = min(counts)
                max_val = max(counts)
                width = (max_val - min_val) / (max_display-1)
                for i in range(max_display-1):
                    lower = min_val + width*i
                    upper = min_val + width*(i+1)
                    if (i == (max_display - 2)):
                        num = sum(counts[v] for v in counts if lower <= v <= upper)
                        cap = "]"
                    else:
                        num = sum(counts[v] for v in counts if lower <= v < upper)
                        cap = ")"
                    perc = 100. * (num / len(self))
                    print_to_file(f"    [{lower:9.2e}, {upper:9.2e}{cap} {num:{len(str(len(self)))}d} ({perc:5.1f}%) {'#'*round(perc/2)}")
            else:
                if t in {int, float}:
                    # Order the values by their inate ordering
                    ordered_vals = sorted(counts)
                else:
                    # Order the values by their frequency and print
                    ordered_vals = sorted(counts, key=lambda v: -counts[v])
                val_len = max(map(lambda v: len(str(v)), counts))
                val_len = max(val_len, len("None"))
                val_len = min(val_len, self.max_str_len)
                if (t == str): val_len += 2
                if (none_count > 0):
                    perc = 100. * (none_count / len(self))
                    print_to_file(f"    {'None':{val_len}s}{'  ' if (t == str) else ''} {none_count:{len(str(len(self)))}d} ({perc:5.1f}%) {'#'*round(perc/2)}")
                for val in ordered_vals[:max_display]:
                    perc = 100. * (counts[val] / len(self))
                    if (t == str):
                        print_to_file(f"    \"{val}\"{'':{1+val_len-len(str(val))}s}{counts[val]:{len(str(len(self)))}d} ({perc:5.1f}%) {'#'*round(perc/2)}")
                    else:
                        print_to_file(f"    {self._val_to_str(val):{val_len}s} {counts[val]:{len(str(len(self)))}d} ({perc:5.1f}%) {'#'*round(perc/2)}")
                if (len(ordered_vals) > max_display):
                    print_to_file("    ... (increase 'max_display' to see more summary statistics).")
            print_to_file()




