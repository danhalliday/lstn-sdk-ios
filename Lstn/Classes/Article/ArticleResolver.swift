//
//  ArticleResolver.swift
//  Pods
//
//  Created by Dan Halliday on 09/11/2016.
//
//

protocol ArticleResolver {

    func resolve(key: ArticleKey)

    weak var delegate: ArticleResolverDelegate? { get set }

}

protocol ArticleResolverDelegate: class {

    func resolutionDidStart(key: ArticleKey)
    func resolutionDidFinish(key: ArticleKey, article: Article)
    func resolutionDidFail(key: ArticleKey)

}
