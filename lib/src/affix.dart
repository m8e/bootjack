part of bootjack;

/**
 * 
 */
class Affix extends Base {
  
  static const _name = 'affix';
  
  static const _defaultOffset = 10;
  final _AsInt offsetTop, offsetBottom;
  
  /** 
   * 
   */
  Affix(Element element, {int offsetTop(), int offsetBottom()}) : 
  this.offsetTop = offsetTop ?? (() => _defaultOffset),
  this.offsetBottom = offsetBottom ?? (() => _defaultOffset),
  super(element, _name) {
    $(window)
    ..on('scroll.affix.data-api', (QueryEvent e) => checkPosition())
    ..on('click.affix.data-api', (QueryEvent e) {
      new Timer(const Duration(milliseconds: 1), checkPosition);
    });
    checkPosition();
  }
  
  /**
   * 
   */
  static Affix wire(Element element, [Affix create()]) =>
      p.wire(element, _name, create ?? (() => new Affix(element)));
  
  /**
   * 
   */
  void checkPosition() {
    if (p.isHidden(element))
      return;
    
    final int offsetTop = this.offsetTop() ?? _defaultOffset;
    final int offsetBottom = this.offsetBottom() ?? _defaultOffset;
    
    final int scrollHeight = $document().height;
    final int scrollTop = window.pageYOffset;
    final int positionTop = element.offsetTop;
    
    String affix = _unpin != null && scrollTop + _unpin <= positionTop ? 'false' : 
      offsetBottom != null && (positionTop + element.offsetHeight >= scrollHeight - offsetBottom) ? 'bottom' :
      offsetTop != null && scrollTop <= offsetTop ? 'top' : 'false';
    
    if (_affixed == affix)
      return;
    _affixed = affix;
    _unpin = affix == 'bottom' ? positionTop - scrollTop : null;
    
    element.classes
    ..remove('affix')
    ..remove('affix-top')
    ..remove('affix-bottom')
    ..add(affix == 'bottom' ? 'affix-bottom' : affix == 'top' ? 'affix-top' : 'affix');
    
  }
  
  String _affixed;
  int _unpin;
  
  static bool _registered = false;
  
  /** Register to use Affix component.
   */
  static void use() {
    if (_registered) return;
    _registered = true;
    
    $window().on('load', (QueryEvent e) {
      for (Element elem in $('[data-spy="affix"]')) {
        // TODO: pass data
        /*
        data.offset = data.offset || {}
        data.offsetBottom && (data.offset.bottom = data.offsetBottom)
        data.offsetTop && (data.offset.top = data.offsetTop)
        */
        Affix.wire(elem);
      }
    });
  }
  
}

typedef int _AsInt();

/*
 // AFFIX PLUGIN DEFINITION
 // ======================= 

  var old = $.fn.affix

  $.fn.affix = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('affix')
        , options = typeof option == 'object' && option
      if (!data) $this.data('affix', (data = new Affix(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }

*/