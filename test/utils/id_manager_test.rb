# <penkovsky at mail dot ua>

require 'test/unit'
require 'lib/utils/id_manager'

class IdManagerMock < IdManager
  def registry
    return @registry
  end
end

class IdManagerTest < Test::Unit::TestCase
  def setup
    @d = IdManagerMock.new
  end
  
  def test_reg
    assert @d.reg('test') == 1
    assert @d.reg('test') == 1
    assert @d.registry == {1 => 'test'}
    assert @d.reg('new') == 2
  end
  
  def test_get_by_id
    @d.reg('Test')
    assert @d.get_by_id(1) == 'Test'
  end
end
