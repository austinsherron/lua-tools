local TestUtils = require 'toolbox.test.utils'

local assert = require 'luassert.assert'


describe('TestUtils', function()
  describe('.is_empty(o)', function()
    describe('o is string', function()
      it('should return true if str is empty', function()
        assert.True(TestUtils.is_empty(''))
      end)
      it('should return false if str is empty', function()
        assert.False(TestUtils.is_empty('string'))
        assert.False(TestUtils.is_empty(' string'))
        assert.False(TestUtils.is_empty('string '))
        assert.False(TestUtils.is_empty(' string '))
        assert.False(TestUtils.is_empty(' '))
        assert.False(TestUtils.is_empty('\n'))
        assert.False(TestUtils.is_empty('\t'))
        assert.False(TestUtils.is_empty('\r'))
      end)
    end)

    describe('o is table', function()
      it('should return true if tbl is empty', function()
        assert.True(TestUtils.is_empty({}))
      end)
      it('should return false if tbl is not empty', function()
        assert.False(TestUtils.is_empty({ 'a' }))
        assert.False(TestUtils.is_empty({ 'a', 'b', 'z', 1 }))
        assert.False(TestUtils.is_empty({ a = 1 }))
        assert.False(TestUtils.is_empty({ a = 1, z = 26, f = 5 }))
      end)
    end)
  end)

  describe('.not_nil_or_empty(o)', function()
    it('should return false if o is nil', function()
      assert.False(TestUtils.not_nil_or_empty(nil))
    end)

    describe('o is string', function()
      it('should return true if o is not empty', function()
        assert.True(TestUtils.not_nil_or_empty('string'))
        assert.True(TestUtils.not_nil_or_empty(' string'))
        assert.True(TestUtils.not_nil_or_empty('string '))
        assert.True(TestUtils.not_nil_or_empty(' string '))
        assert.True(TestUtils.not_nil_or_empty(' '))
        assert.True(TestUtils.not_nil_or_empty('\n'))
        assert.True(TestUtils.not_nil_or_empty('\t'))
        assert.True(TestUtils.not_nil_or_empty('\r'))
      end)
      it('should return false if o is empty', function()
        assert.False(TestUtils.not_nil_or_empty(''))
      end)
      it('should return false if o is nil', function()
        assert.False(TestUtils.not_nil_or_empty(nil))
      end)
    end)

    describe('o is table', function()
      it('should return true if o is not empty', function()
        assert.True(TestUtils.not_nil_or_empty({ 'a' }))
        assert.True(TestUtils.not_nil_or_empty({ 'a', 'b', 'z', 1 }))
        assert.True(TestUtils.not_nil_or_empty({ a = 1 }))
        assert.True(TestUtils.not_nil_or_empty({ a = 1, z = 26, f = 5 }))
      end)
      it('should return false if o is empty', function()
        assert.False(TestUtils.not_nil_or_empty({}))
      end)
    end)
  end)

  describe('.table_len(tbl)', function()
    it('should compute the lengths of array-like tables', function()
      assert.equals(TestUtils.table_len({ 'a' }), 1)
      assert.equals(TestUtils.table_len({ 'a', 'b' }), 2)
      assert.equals(TestUtils.table_len({ 'a', 'b', 'c' }), 3)
    end)
    it('should compute the lengths of dict-like tables', function()
      assert.equals(TestUtils.table_len({ a = 1 }), 1)
      assert.equals(TestUtils.table_len({ a = 1, b = 2 }), 2)
      assert.equals(TestUtils.table_len({ a = 1, b = 2, c = 3 }), 3)
    end)
    it('should compute the lengths of empty tables', function()
      assert.equals(TestUtils.table_len({}), 0)
    end)
    it("shouldn't count nil entries in lenght computation", function()
      assert.equals(TestUtils.table_len({ nil }), 0)
      assert.equals(TestUtils.table_len({ nil, nil }), 0)
      assert.equals(TestUtils.table_len({ 2, nil, 3 }), 2)

      assert.equals(TestUtils.table_len({ a = nil }), 0)
      assert.equals(TestUtils.table_len({ a = nil, b = nil }), 0)
      assert.equals(TestUtils.table_len({ a = nil, c = 0, b = nil, l = -1 }), 2)
    end)
  end)

  describe('.table_contains(l, r)', function()
    it('should return true if l and r contain the same key/value pairs', function()
      assert.True(TestUtils.table_contains(
        { a = 1 },
        { a = 1 }
      ))
      assert.True(TestUtils.table_contains(
        { b = 2, a = 1 },
        { a = 1, b = 2 }
      ))
    end)
    it('should return true if r contains all key/value pairs in l', function()
      assert.True(TestUtils.table_contains(
        { a = 1, b = 2 },
        { b = 2, a = 1, c = 3 }
      ))
    end)
    it("should return false if r doesn't contain all key/value pairs in l", function()
      assert.False(TestUtils.table_contains(
        { a = 1 },
        { b = 2 }
      ))
      assert.False(TestUtils.table_contains(
        { b = 2, a = 1, c = 3 },
        { a = 1, b = 2 }
      ))
      assert.False(TestUtils.table_contains(
        { a = 1, b = 2, c = 4 },
        { b = 2, a = 1, c = 3 }
      ))
      assert.False(TestUtils.table_contains(
        { a = 1, b = 2, d = 3 },
        { b = 2, a = 1, c = 3 }
      ))
    end)
    it('should return true if l and r contain the same elements in the same order', function()
      assert.True(TestUtils.table_contains(
        { 1 },
        { 1 }
      ))
      assert.True(TestUtils.table_contains(
        { 1, 2, 3 },
        { 1, 2, 3 }
      ))
    end)
    it('should return false if l and r contain the same elements in different order', function()
      assert.False(TestUtils.table_contains(
        { 1, 2, 3 },
        { 3, 2, 1 }
      ))
    end)
    it('should return true if r contains all elements of l in the same order', function()
      assert.True(TestUtils.table_contains(
        { 1 },
        { 1, 2 }
      ))
      assert.True(TestUtils.table_contains(
        { 1, 2 },
        { 1, 2, 3 }
      ))
    end)
    it("should return false if r doesn't contain all elements of l in the same order", function()
      assert.False(TestUtils.table_contains(
        { 1, 2 },
        { 1 }
      ))
      assert.False(TestUtils.table_contains(
        { 1, 2 },
        { 3, 1, 2 }
      ))
      assert.False(TestUtils.table_contains(
        { 1, 2, 3 },
        { 1, 2, 4 }
      ))
    end)
    it('should return true if both tables are empty', function()
      assert.True(TestUtils.table_contains({}, {}))
    end)
  end)

  describe('.table_equals(l, r)', function()
    it('should return true if l and r contain the same key/value pairs', function()
      assert.True(TestUtils.table_equals(
        { a = 1 },
        { a = 1 }
      ))
      assert.True(TestUtils.table_equals(
        { b = 2, a = 1 },
        { a = 1, b = 2 }
      ))
    end)
    it('should return false if l and r contain different key/value pairs', function()
      assert.False(TestUtils.table_equals(
        { a = 1 },
        { b = 2 }
      ))
      assert.False(TestUtils.table_equals(
        { b = 2, a = 1, c = 3 },
        { a = 1, b = 2 }
      ))
      assert.False(TestUtils.table_equals(
        { a = 1, b = 2 },
        { b = 2, a = 1, c = 3 }
      ))
      assert.False(TestUtils.table_equals(
        { a = 1, b = 2, c = 4 },
        { b = 2, a = 1, c = 3 }
      ))
      assert.False(TestUtils.table_equals(
        { a = 1, b = 2, d = 3 },
        { b = 2, a = 1, c = 3 }
      ))
    end)
    it('should return true if l and r contain the same elements in the same order', function()
      assert.True(TestUtils.table_equals(
        { 1 },
        { 1 }
      ))
      assert.True(TestUtils.table_equals(
        { 1, 2, 3 },
        { 1, 2, 3 }
      ))
    end)
    it('should return false if l and r contain the same elements in different order', function()
      assert.False(TestUtils.table_equals(
        { 1, 2, 3 },
        { 3, 2, 1 }
      ))
    end)
    it('should return false if l and r contain the contain different elements', function()
      assert.False(TestUtils.table_equals(
        { 1 },
        { 1, 2 }
      ))
      assert.False(TestUtils.table_equals(
        { 1, 2 },
        { 1 }
      ))
      assert.False(TestUtils.table_equals(
        { 1, 2, 3 },
        { 1, 2, 4 }
      ))
    end)
    it('should return true if both tables are empty', function()
      assert.True(TestUtils.table_equals({}, {}))
    end)
  end)

  describe('.to_set(arr)', function ()
    it('should create a set-like table from arr', function()
      assert.same(TestUtils.to_set({ 'a', 'b', 'c' }), { a = true, b = true, c = true })
      assert.same(TestUtils.to_set({ 1, 2, 3 }), { [1] = true, [2] = true, [3] = true })
    end)
    it('should work when arr is empty', function()
      assert.same(TestUtils.to_set({}), {})
    end)
  end)
end)
