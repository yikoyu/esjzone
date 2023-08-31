/*
 * @Date: 2023-08-25 10:35:35
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-25 10:35:50
 * @FilePath: \esjzone\lib\app\utils\esjzone\esjzone_selector.dart
 */
import 'package:esjzone/app/data/novel_list_model.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:string_validator/string_validator.dart';

class EsjzoneSelector {
  /// 获取授权
  static String getAuthToken(String? input) {
    if (input == null || input.isEmpty) {
      return '';
    }

    Document doc = parse(input);
    Element? row = doc.querySelector('JinJing');

    if (row == null) {
      return '';
    }

    return row.text;
  }

  /// 获取小说列表
  static List<NovelList> novelList(String? input) {
    if (input == null || input.isEmpty) {
      return <NovelList>[];
    }

    const SELECTOR_ROW =
        'body > div.offcanvas-wrapper > section > div > div.col-xl-9.col-lg-8.p-r-30 > div.row';

    Document doc = parse(input);
    Element? row = doc.querySelector(SELECTOR_ROW);

    if (row == null) {
      return <NovelList>[];
    }

    Iterable<NovelList> items = row.children.map((col) {
      var q = col.querySelector;

      String? img = q('> .main-img > .lazyload')?.attributes['data-src'];

      return NovelList.fromJson({
        'title': q('> h5.card-title > a')?.text,
        'link': q('> h5.card-title > a')?.attributes['href'],
        'img': isURL(img) ? img : null,
        'author': q('> .card-author > a')?.text,
        'last_ep': q('> .card-ep > a')?.text,
        'last_ep_link': q('> .card-ep > a')?.attributes['href'],
        'stars': q('> i.icon-star-s')?.parent?.text.trim(),
        'words': q('> i.icon-file-text')?.parent?.text.trim(),
        'views': q('> i.icon-eye')?.parent?.text.trim(),
        'favorite': q('> i.icon-heart')?.parent?.text.trim(),
        'feathers': q('> i.icon-feather')?.parent?.text.trim(),
        'messages': q('> i.icon-message-square')?.parent?.text.trim(),
        'x_rated': q('> .product-badge')?.text == '18+'
      });
    });

    return items.toList();
  }

  /// 获取热门搜索
  static List<String> hotTagList(String? input) {
    if (input == null || input.isEmpty) {
      return <String>[];
    }

    const SELECTOR_TAG =
        'body > div.offcanvas-wrapper .show-tag > .alert.alert-primary > ul > a > li';

    Document doc = parse(input);
    List<Element>? tagElList = doc.querySelectorAll(SELECTOR_TAG);
    List<String> tags = tagElList.map((e) => e.text).toList();

    return tags;
  }
}
