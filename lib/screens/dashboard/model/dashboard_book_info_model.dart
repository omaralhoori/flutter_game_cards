import 'package:bookkart_flutter/screens/dashboard/model/card_model.dart';
import 'package:nb_utils/nb_utils.dart';

class DashboardResponse {
  SocialLink? socialLink;
  String? appLang;
  String? paymentMethod;
  bool? enableCoupons;
  CurrencySymbol? currencySymbol;
  List<BookDataModel>? suggestedForYou;
  List<BookDataModel>? youMayLike;
  List<BookDataModel>? featured;
  List<BookDataModel>? newest;
  List<Category>? category;

  DashboardResponse({this.socialLink, this.appLang, this.paymentMethod, this.enableCoupons, this.currencySymbol, this.suggestedForYou, this.category, this.youMayLike, this.featured, this.newest});

  DashboardResponse.fromJson(Map<String, dynamic> json) {
    socialLink = json['social_link'] != null ? new SocialLink.fromJson(json['social_link']) : null;
    appLang = json['app_lang'];
    paymentMethod = json['payment_method'];
    enableCoupons = json['enable_coupons'];
    currencySymbol = json['currency_symbol'] != null ? new CurrencySymbol.fromJson(json['currency_symbol']) : null;
    if (json['suggested_for_you'] != null) {
      suggestedForYou = <BookDataModel>[];
      json['suggested_for_you'].forEach((v) {
        suggestedForYou!.add(new BookDataModel.fromJson(v));
      });
    }
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(new Category.fromJson(v));
      });
    }
    if (json['you_may_like'] != null) {
      youMayLike = <BookDataModel>[];
      json['you_may_like'].forEach((v) {
        youMayLike!.add(new BookDataModel.fromJson(v));
      });
    }
    if (json['featured'] != null) {
      featured = <BookDataModel>[];
      json['featured'].forEach((v) {
        featured!.add(new BookDataModel.fromJson(v));
      });
    }
    if (json['newest'] != null) {
      newest = <BookDataModel>[];
      json['newest'].forEach((v) {
        newest!.add(new BookDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.socialLink != null) {
      data['social_link'] = this.socialLink!.toJson();
    }
    data['app_lang'] = this.appLang;
    data['payment_method'] = this.paymentMethod;
    data['enable_coupons'] = this.enableCoupons;
    if (this.currencySymbol != null) {
      data['currency_symbol'] = this.currencySymbol!.toJson();
    }
    if (this.suggestedForYou != null) {
      data['suggested_for_you'] = this.suggestedForYou!.map((v) => v.toJson()).toList();
    }
    if (this.youMayLike != null) {
      data['you_may_like'] = this.youMayLike!.map((v) => v.toJson()).toList();
    }
    if (this.featured != null) {
      data['featured'] = this.featured!.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    if (this.newest != null) {
      data['newest'] = this.newest!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  int? termId;
  String? name;
  String? slug;
  int? termGroup;
  int? termTaxonomyId;
  String? taxonomy;
  String? description;
  int? parent;
  int? count;
  String? filter;
  int? catID;
  int? categoryCount;
  String? categoryDescription;
  String? catName;
  String? categoryNicename;
  int? categoryParent;
  List<CardModel>? product;
  String? image;

  Category(
      {this.termId,
      this.name,
      this.slug,
      this.termGroup,
      this.termTaxonomyId,
      this.taxonomy,
      this.description,
      this.parent,
      this.count,
      this.filter,
      this.catID,
      this.categoryCount,
      this.categoryDescription,
      this.catName,
      this.categoryNicename,
      this.categoryParent,
      this.product,
      this.image});

  Category.fromJson(Map<String, dynamic> json) {
    termId = json['term_id'];
    name = json['name'];
    slug = json['slug'];
    termGroup = json['term_group'];
    termTaxonomyId = json['term_taxonomy_id'];
    taxonomy = json['taxonomy'];
    description = json['description'];
    parent = json['parent'];
    count = json['count'];
    filter = json['filter'];
    catID = json['cat_ID'];
    categoryCount = json['category_count'];
    categoryDescription = json['category_description'];
    catName = json['cat_name'];
    categoryNicename = json['category_nicename'];
    categoryParent = json['category_parent'];
    if (json['product'] != null) {
      product = <CardModel>[];
      json['product'].forEach((v) {
        //product!.add(new BookDataModel.fromJson(v));
      });
    }
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['term_id'] = this.termId;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['term_group'] = this.termGroup;
    data['term_taxonomy_id'] = this.termTaxonomyId;
    data['taxonomy'] = this.taxonomy;
    data['description'] = this.description;
    data['parent'] = this.parent;
    data['count'] = this.count;
    data['filter'] = this.filter;
    data['cat_ID'] = this.catID;
    data['category_count'] = this.categoryCount;
    data['category_description'] = this.categoryDescription;
    data['cat_name'] = this.catName;
    data['category_nicename'] = this.categoryNicename;
    data['category_parent'] = this.categoryParent;
    if (this.product != null) {
     // data['product'] = this.product!.map((v) => v.toJson()).toList();
    }
    data['image'] = this.image;
    return data;
  }
}

class SocialLink {
  String? whatsapp;
  String? facebook;
  String? twitter;
  String? instagram;
  String? contact;
  String? privacyPolicy;
  String? copyrightText;
  String? termCondition;

  SocialLink({this.whatsapp, this.facebook, this.twitter, this.instagram, this.contact, this.privacyPolicy, this.copyrightText, this.termCondition});

  SocialLink.fromJson(Map<String, dynamic> json) {
    whatsapp = json['whatsapp'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    instagram = json['instagram'];
    contact = json['contact'];
    privacyPolicy = json['privacy_policy'];
    copyrightText = json['copyright_text'];
    termCondition = json['term_condition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['whatsapp'] = this.whatsapp;
    data['facebook'] = this.facebook;
    data['twitter'] = this.twitter;
    data['instagram'] = this.instagram;
    data['contact'] = this.contact;
    data['privacy_policy'] = this.privacyPolicy;
    data['copyright_text'] = this.copyrightText;
    data['term_condition'] = this.termCondition;
    return data;
  }
}

class CurrencySymbol {
  String? currencySymbol;
  String? currency;

  CurrencySymbol({this.currencySymbol, this.currency});

  CurrencySymbol.fromJson(Map<String, dynamic> json) {
    currencySymbol = json['currency_symbol'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currency_symbol'] = this.currencySymbol;
    data['currency'] = this.currency;
    return data;
  }
}

class AuthorResponse {
  int? id;
  String? storeName;
  String? firstName;
  String? lastName;
  String? name;
  String? phone;
  String? image;
  bool? showEmail;
  String? location;
  String? banner;
  int? bannerId;
  String? gravatar;
  int? gravatarId;
  String? shopUrl;
  int? productsPerPage;
  bool? showMoreProductTab;
  bool? tocEnabled;
  String? storeToc;
  bool? featured;
  Rating? rating;
  bool? enabled;
  String? registered;
  String? payment;
  bool? trusted;

  AuthorResponse({
    this.id,
    this.storeName,
    this.firstName,
    this.name,
    this.lastName,
    this.phone,
    this.showEmail,
    this.location,
    this.banner,
    this.bannerId,
    this.gravatar,
    this.gravatarId,
    this.image,
    this.shopUrl,
    this.productsPerPage,
    this.showMoreProductTab,
    this.tocEnabled,
    this.storeToc,
    this.featured,
    this.rating,
    this.enabled,
    this.registered,
    this.payment,
    this.trusted,
  });

  AuthorResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeName = json['shop_name'];
    firstName = json['first_name'];
    name = json['name'];
    lastName = json['last_name'];
    phone = json['phone'];
    showEmail = json['show_email'];
    location = json['location'];
    banner = json['banner'];
    bannerId = json['banner_id'];
    gravatar = json['gravatar'];
    gravatarId = json['gravatar_id'];
    shopUrl = json['url'];
    productsPerPage = json['products_per_page'];
    showMoreProductTab = json['show_more_product_tab'];
    tocEnabled = json['toc_enabled'];
    image = json['image'];
    storeToc = json['store_toc'];
    featured = json['featured'];
    rating = json['rating'] != null ? new Rating.fromJson(json['rating']) : null;
    enabled = json['enabled'];
    registered = json['registered'];
    payment = json['payment'];
    trusted = json['trusted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shop_name'] = this.storeName;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['phone'] = this.phone;
    data['show_email'] = this.showEmail;
    data['location'] = this.location;
    data['image'] = this.image;
    data['banner'] = this.banner;
    data['banner_id'] = this.bannerId;
    data['gravatar'] = this.gravatar;
    data['name'] = this.name;
    data['gravatar_id'] = this.gravatarId;
    data['url'] = this.shopUrl;
    data['products_per_page'] = this.productsPerPage;
    data['show_more_product_tab'] = this.showMoreProductTab;
    data['toc_enabled'] = this.tocEnabled;
    data['store_toc'] = this.storeToc;
    data['featured'] = this.featured;
    if (this.rating != null) {
      data['rating'] = this.rating!.toJson();
    }
    data['enabled'] = this.enabled;
    data['registered'] = this.registered;
    data['payment'] = this.payment;
    data['trusted'] = this.trusted;

    return data;
  }
}

class Rating {
  String? rating;
  int? count;

  Rating({this.rating, this.count});

  Rating.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating'] = this.rating;
    data['count'] = this.count;
    return data;
  }
}

class BookDataModel {
  int? id;
  String? name;
  String? slug;
  String? permalink;
  String? dateCreated;
  String? dateModified;
  String? type;
  String? status;
  bool? featured;
  String? catalogVisibility;
  String? description;
  String? shortDescription;
  String? sku;
  num? price;
  num? regularPrice;
  num? salePrice;
  String? dateOnSaleFrom;
  String? dateOnSaleTo;
  String? priceHtml;
  bool? onSale;
  bool? purchasable;
  int? totalSales;
  bool? virtual;
  bool? downloadable;
  List<DownloadModel>? downloads;
  int? downloadLimit;
  int? downloadExpiry;
  String? downloadType;
  String? externalUrl;
  String? buttonText;
  String? taxStatus;
  String? taxClass;
  bool? manageStock;
  bool? inStock;
  String? backorders;
  bool? backordersAllowed;
  bool? backordered;
  bool? soldIndividually;
  String? weight;
  Dimensions? dimensions;
  bool? shippingRequired;
  bool? shippingTaxable;
  String? shippingClass;
  int? shippingClassId;
  bool? reviewsAllowed;
  String? averageRating;
  int? ratingCount;
  List<int>? upsellIds;
  List<int>? crossSellIds;
  int? parentId;
  String? purchaseNote;
  List<Categories>? categories;
  List<Images>? images;
  List<Attributes>? attributes;
  List<UpsellId>? upsellId;
  int? menuOrder;
  List<Reviews>? reviews;
  AuthorResponse? store;
  bool? isAddedCart;
  bool? isAddedWishlist;
  bool? isPurchased = false;

  // Local
  bool get isFreeBook => (price.validate() == 0 && salePrice.validate() == 0 && regularPrice.validate() == 0);

  String get img {
    if (images == null) return '';
    return images.validate().first.src.validate();
  }

  bool get isPaid {
    return !((price.validate().toDouble() == 0) && (salePrice.validate().toString().validate().toDouble() == 0) && regularPrice.validate().toDouble() == 0) &&
        regularPrice.toString().isNotEmpty &&
        salePrice.validate().toString().toString().isNotEmpty;
  }

  BookDataModel({
    this.id,
    this.name,
    this.slug,
    this.permalink,
    this.dateCreated,
    this.dateModified,
    this.type,
    this.status,
    this.featured,
    this.catalogVisibility,
    this.description,
    this.shortDescription,
    this.sku,
    this.price,
    this.regularPrice,
    this.salePrice,
    this.dateOnSaleFrom,
    this.dateOnSaleTo,
    this.priceHtml,
    this.onSale,
    this.purchasable,
    this.totalSales,
    this.virtual,
    this.downloadable,
    this.downloads,
    this.downloadLimit,
    this.downloadExpiry,
    this.downloadType,
    this.externalUrl,
    this.buttonText,
    this.taxStatus,
    this.taxClass,
    this.manageStock,
    this.inStock,
    this.backorders,
    this.backordersAllowed,
    this.backordered,
    this.soldIndividually,
    this.weight,
    this.dimensions,
    this.shippingRequired,
    this.shippingTaxable,
    this.shippingClass,
    this.shippingClassId,
    this.reviewsAllowed,
    this.averageRating,
    this.ratingCount,
    this.upsellIds,
    this.crossSellIds,
    this.parentId,
    this.purchaseNote,
    this.categories,
    this.images,
    this.attributes,
    this.upsellId,
    this.menuOrder,
    this.reviews,
    this.store,
    this.isAddedCart,
    this.isPurchased,
    this.isAddedWishlist,
  });

  String get getImage => images.validate().first.src.validate();

  BookDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    permalink = json['permalink'];
    dateCreated = json['date_created'];
    dateModified = json['date_modified'];
    type = json['type'];
    status = json['status'];
    featured = json['featured'];
    catalogVisibility = json['catalog_visibility'];
    description = json['description'];
    shortDescription = json['short_description'];
    sku = json['sku'];
    price = (json['price'] is String).toString().isNotEmpty ? json['price'].toString().toDouble() : 0;
    regularPrice = (json['regular_price'] is String).toString().isNotEmpty ? json['regular_price'].toString().toDouble() : 0;
    salePrice = (json['sale_price'] is String).toString().isNotEmpty ? json['sale_price'].toString().toDouble() : 0;
    dateOnSaleFrom = json['date_on_sale_from'];
    dateOnSaleTo = json['date_on_sale_to'];
    priceHtml = json['price_html'];
    onSale = json['on_sale'];
    purchasable = json['purchasable'];
    totalSales = json['total_sales'];
    virtual = json['virtual'];
    downloadable = json['downloadable'];
    if (json['downloads'] != null) {
      downloads = <DownloadModel>[];
      json['downloads'].forEach((v) {
        downloads!.add(new DownloadModel.fromJson(v));
      });
    }
    downloadLimit = json['download_limit'];
    downloadExpiry = json['download_expiry'];
    downloadType = json['download_type'];
    externalUrl = json['external_url'];
    buttonText = json['button_text'];
    taxStatus = json['tax_status'];
    taxClass = json['tax_class'];
    manageStock = json['manage_stock'];
    inStock = json['in_stock'];
    backorders = json['backorders'];
    backordersAllowed = json['backorders_allowed'];
    backordered = json['backordered'];
    soldIndividually = json['sold_individually'];
    weight = json['weight'];
    dimensions = json['dimensions'] != null ? new Dimensions.fromJson(json['dimensions']) : null;
    shippingRequired = json['shipping_required'];
    shippingTaxable = json['shipping_taxable'];
    shippingClass = json['shipping_class'];
    shippingClassId = json['shipping_class_id'];
    reviewsAllowed = json['reviews_allowed'];
    averageRating = json['average_rating'];
    ratingCount = json['rating_count'];

    upsellIds = json['upsell_ids'].cast<int>();
    crossSellIds = json['cross_sell_ids'].cast<int>();
    parentId = json['parent_id'];
    purchaseNote = json['purchase_note'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }

    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    if (json['attributes'] != null) {
      attributes = <Attributes>[];
      json['attributes'].forEach((v) {
        attributes!.add(new Attributes.fromJson(v));
      });
    }

    if (json['upsell_id'] != null) {
      upsellId = <UpsellId>[];
      json['upsell_id'].forEach((v) {
        upsellId!.add(new UpsellId.fromJson(v));
      });
    }
    menuOrder = json['menu_order'];
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(new Reviews.fromJson(v));
      });
    }
    store = json['store'] != null ? new AuthorResponse.fromJson(json['store']) : null;
    isAddedCart = json['is_added_cart'];
    isPurchased = json['is_purchased'];
    isAddedWishlist = json['is_added_wishlist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['permalink'] = this.permalink;
    data['date_created'] = this.dateCreated;
    data['date_modified'] = this.dateModified;
    data['type'] = this.type;
    data['status'] = this.status;
    data['featured'] = this.featured;
    data['catalog_visibility'] = this.catalogVisibility;
    data['description'] = this.description;
    data['short_description'] = this.shortDescription;
    data['sku'] = this.sku;
    data['price'] = this.price;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['date_on_sale_from'] = this.dateOnSaleFrom;
    data['date_on_sale_to'] = this.dateOnSaleTo;
    data['price_html'] = this.priceHtml;
    data['on_sale'] = this.onSale;
    data['purchasable'] = this.purchasable;
    data['total_sales'] = this.totalSales;
    data['virtual'] = this.virtual;
    data['downloadable'] = this.downloadable;
    if (this.downloads != null) {
      data['downloads'] = this.downloads!.map((v) => v.toJson()).toList();
    }
    data['download_limit'] = this.downloadLimit;
    data['download_expiry'] = this.downloadExpiry;
    data['download_type'] = this.downloadType;
    data['external_url'] = this.externalUrl;
    data['button_text'] = this.buttonText;
    data['tax_status'] = this.taxStatus;
    data['tax_class'] = this.taxClass;
    data['manage_stock'] = this.manageStock;
    data['in_stock'] = this.inStock;
    data['backorders'] = this.backorders;
    data['backorders_allowed'] = this.backordersAllowed;
    data['backordered'] = this.backordered;
    data['sold_individually'] = this.soldIndividually;
    data['weight'] = this.weight;
    if (this.dimensions != null) {
      data['dimensions'] = this.dimensions!.toJson();
    }
    data['shipping_required'] = this.shippingRequired;
    data['shipping_taxable'] = this.shippingTaxable;
    data['shipping_class'] = this.shippingClass;
    data['shipping_class_id'] = this.shippingClassId;
    data['reviews_allowed'] = this.reviewsAllowed;
    data['average_rating'] = this.averageRating;
    data['rating_count'] = this.ratingCount;

    data['upsell_ids'] = this.upsellIds;
    data['cross_sell_ids'] = this.crossSellIds;
    data['parent_id'] = this.parentId;
    data['purchase_note'] = this.purchaseNote;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }

    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.map((v) => v.toJson()).toList();
    }

    if (this.upsellId != null) {
      data['upsell_id'] = this.upsellId!.map((v) => v.toJson()).toList();
    }
    data['menu_order'] = this.menuOrder;
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    if (this.store != null) {
      data['store'] = this.store!.toJson();
    }
    data['is_added_cart'] = this.isAddedCart;
    data['is_added_wishlist'] = this.isAddedWishlist;
    data['is_purchased'] = this.isPurchased;
    return data;
  }
}

class DownloadModel {
  String? id;
  String? name;
  String? file;

  //Local Variable
  String get filename => file.validate().substring(file.validate().lastIndexOf("/") + 1);

  DownloadModel({this.id, this.name, this.file});

  DownloadModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['file'] = this.file;
    return data;
  }
}

class Dimensions {
  String? length;
  String? width;
  String? height;

  Dimensions({this.length, this.width, this.height});

  Dimensions.fromJson(Map<String, dynamic> json) {
    length = json['length'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['length'] = this.length;
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  String? slug;

  Categories({this.id, this.name, this.slug});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}

class Images {
  int? id;
  String? dateCreated;
  String? dateModified;
  String? src;
  String? name;
  String? alt;
  int? position;

  Images({this.id, this.dateCreated, this.dateModified, this.src, this.name, this.alt, this.position});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateCreated = json['date_created'];
    dateModified = json['date_modified'];
    src = json['src'];
    name = json['name'];
    alt = json['alt'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date_created'] = this.dateCreated;
    data['date_modified'] = this.dateModified;
    data['src'] = this.src;
    data['name'] = this.name;
    data['alt'] = this.alt;
    data['position'] = this.position;
    return data;
  }
}

class Attributes {
  int? id;
  String? name;
  int? position;
  bool? visible;
  bool? variation;
  List<String>? options;

  Attributes({this.id, this.name, this.position, this.visible, this.variation, this.options});

  Attributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    position = json['position'];
    visible = json['visible'];
    variation = json['variation'];
    options = json['options'] != null ? new List<String>.from(json['options']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['position'] = this.position;
    data['visible'] = this.visible;
    data['variation'] = this.variation;
    data['options'] = this.options;
    return data;
  }
}

class UpsellId {
  int? id;
  String? name;
  String? slug;
  String? price;
  String? regularPrice;
  String? salePrice;
  List<Images>? images;

  UpsellId({this.id, this.name, this.slug, this.price, this.regularPrice, this.salePrice, this.images});

  UpsellId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    price = json['price'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['price'] = this.price;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reviews {
  String? commentID;
  String? commentPostID;
  String? commentAuthor;
  String? commentAuthorEmail;
  String? commentAuthorUrl;
  String? commentAuthorIP;
  String? commentDate;
  String? commentDateGmt;
  String? commentContent;
  String? commentKarma;
  String? commentApproved;
  String? commentAgent;
  String? commentType;
  String? commentParent;
  String? userId;
  String? ratingNum = "0";
  String? dateCreated;
  String? email;
  int? id;
  String? name;
  int? rating;
  String? review;
  bool? verified;

  Reviews(
      {this.commentID,
      this.commentPostID,
      this.commentAuthor,
      this.commentAuthorEmail,
      this.commentAuthorUrl,
      this.commentAuthorIP,
      this.commentDate,
      this.commentDateGmt,
      this.commentContent,
      this.commentKarma,
      this.commentApproved,
      this.commentAgent,
      this.commentType,
      this.commentParent,
      this.ratingNum,
      this.userId,
      this.dateCreated,
      this.email,
      this.id,
      this.name,
      this.rating,
      this.review,
      this.verified});

  Reviews.fromJson(Map<String, dynamic> json) {
    commentID = json['comment_ID'];
    commentPostID = json['comment_post_ID'];
    commentAuthor = json['comment_author'];
    commentAuthorEmail = json['comment_author_email'];
    commentAuthorUrl = json['comment_author_url'];
    commentAuthorIP = json['comment_author_IP'];
    commentDate = json['comment_date'];
    commentDateGmt = json['comment_date_gmt'];
    commentContent = json['comment_content'];
    commentKarma = json['comment_karma'];
    commentApproved = json['comment_approved'];
    commentAgent = json['comment_agent'];
    commentType = json['comment_type'];
    ratingNum = json['rating_num'];
    commentParent = json['comment_parent'];
    userId = json['user_id'];

    dateCreated = json['date_created'];
    email = json['email'];
    id = json['id'];
    name = json['name'];
    rating = json['rating'];
    review = json['review'];
    verified = json['verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment_ID'] = this.commentID;
    data['comment_post_ID'] = this.commentPostID;
    data['comment_author'] = this.commentAuthor;
    data['comment_author_email'] = this.commentAuthorEmail;
    data['comment_author_url'] = this.commentAuthorUrl;
    data['comment_author_IP'] = this.commentAuthorIP;
    data['comment_date'] = this.commentDate;
    data['comment_date_gmt'] = this.commentDateGmt;
    data['comment_content'] = this.commentContent;
    data['rating_num'] = this.ratingNum;
    data['comment_karma'] = this.commentKarma;
    data['comment_approved'] = this.commentApproved;
    data['comment_agent'] = this.commentAgent;
    data['comment_type'] = this.commentType;
    data['comment_parent'] = this.commentParent;
    data['user_id'] = this.userId;
    data['date_created'] = this.dateCreated;
    data['email'] = this.email;
    data['id'] = this.id;
    data['name'] = this.name;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['verified'] = this.verified;
    return data;
  }
}

class BookStoreData {
  int? id;
  String? name;
  String? shopName;
  String? url;

  BookStoreData({this.id, this.name, this.shopName, this.url});

  BookStoreData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shopName = json['shop_name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['shop_name'] = this.shopName;
    data['url'] = this.url;

    return data;
  }
}
