local Lambda = require 'toolbox.functional.lambda'

local assert = require 'luassert.assert'

describe('Lambda', function()
  describe('NOOP', function()
    it('should return nil', function()
      assert.Nil(Lambda.NOOP())
    end)
  end)

  describe('TRUE', function()
    it('should return true', function()
      assert.True(Lambda.TRUE())
    end)
  end)

  describe('FALSE', function()
    it('should return false', function()
      assert.False(Lambda.FALSE())
    end)
  end)

  describe('IDENTITY', function()
    it('should return the value', function()
      assert.equals(Lambda.IDENTITY(1), 1)
      assert.equals(Lambda.IDENTITY 'a', 'a')
      assert.equals(Lambda.IDENTITY(true), true)
      assert.equals(Lambda.IDENTITY(false), false)
      assert.same(Lambda.IDENTITY({ a = 1 }), { a = 1 })
    end)
  end)

  describe('EQUALS', function()
    it('should return true if the values are equals', function()
      assert.True(Lambda.EQUALS(1, 1))
      assert.True(Lambda.EQUALS('a', 'a'))
      assert.True(Lambda.EQUALS(true, true))
      assert.True(Lambda.EQUALS(false, false))
    end)
    it("should return false if the values aren't equal", function()
      assert.False(Lambda.EQUALS(1, 2))
      assert.False(Lambda.EQUALS(3, 'z'))
      assert.False(Lambda.EQUALS('a', 'b'))
      assert.False(Lambda.EQUALS(true, false))
      assert.False(Lambda.EQUALS(false, true))
    end)
  end)
end)
